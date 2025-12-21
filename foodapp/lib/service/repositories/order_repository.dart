import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/models/order%20item%20model/order_item_parse.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:foodapp/models/order%20model/order_model_parse.dart';
import 'package:foodapp/service/isar_local/order_local_service.dart';
import 'package:foodapp/service/supabase_remote/order_remote_service.dart';
import 'package:foodapp/service/supabase_remote/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRepository {
  final _local = OrderLocalService();
  final _remote = OrderRemoteService();
  PostgresChangeFilter? filter;

  // Store subscriptions for cleanup
  RealtimeChannel? _ordersChannel;
  RealtimeChannel? _orderItemsChannel;

  /// 🔔 listen to changes in order table [insert, update, delete]
  void listenToOrderChanges() {
    try {
      _ordersChannel = SupabaseService.client
          .channel('public:orders')
          .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'orders',
            filter: filter,
            callback: (payload) {
              fetchOrderByIdFromOnlineDB(
                payload.newRecord['id'] as int,
                // ignore: body_might_complete_normally_catch_error
              ).catchError((e) {
                debugPrint('Error syncing inserted order: $e');
              });
            },
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'orders',
            filter: filter,
            callback: (payload) {
              _syncOrderFromPayload(payload.newRecord).catchError((e) {
                debugPrint('Error syncing updated order: $e');
              });
            },
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.delete,
            schema: 'public',
            table: 'orders',
            filter: filter,
            callback: (payload) {
              _local.deleteOrder(payload.oldRecord['id'] as int).catchError((
                e,
              ) {
                debugPrint('Error syncing deleted order: $e');
              });
            },
          )
          .subscribe();
    } catch (e) {
      debugPrint('Error setting up orders listener: $e');
      rethrow;
    }
  }

  /// 🔔 listen to changes in orderItem table [update, delete]
  void listenToOrderItemsChanges() {
    try {
      _orderItemsChannel = SupabaseService.client
          .channel('public:orderItems')
          .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'orderItems',
            callback: (payload) {
              _syncOrderItemFromPayload(payload.newRecord).catchError((e) {
                debugPrint('Error syncing updated order item: $e');
              });
            },
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.delete,
            schema: 'public',
            table: 'orderItems',
            callback: (payload) {
              _local.deleteOrderItem(payload.oldRecord['id'] as int).catchError(
                (e) {
                  debugPrint('Error syncing deleted order item: $e');
                },
              );
            },
          )
          .subscribe();
    } catch (e) {
      debugPrint('Error setting up order items listener: $e');
      rethrow;
    }
  }

  /// 🧹 cleanup subscriptions
  Future<void> dispose() async {
    try {
      if (_ordersChannel != null) {
        await SupabaseService.client.removeChannel(_ordersChannel!);
      }
      if (_orderItemsChannel != null) {
        await SupabaseService.client.removeChannel(_orderItemsChannel!);
      }
    } catch (e) {
      debugPrint('Error disposing OrderRepository: $e');
      rethrow;
    }
  }

  /// ➕ place order (offline-first)
  Future<void> placeOrder(OrderModel order, List<OrderItemModel> items) async {
    try {
      order.synced = false;
      await _local.insertOrderWithItems(order, items);

      try {
        await _remote.createOrderRPC(order, items);
      } catch (e) {
        debugPrint('Error placing order remotely (will retry): $e');
        // Order stays unsynced, will retry in syncOrders()
      }
    } catch (e) {
      debugPrint('Error placing order: $e');
      rethrow;
    }
  }

  /// 🔄 retry unsynced orders
  Future<void> syncOrders() async {
    try {
      final ordersWithItems = await _local.getUnsyncedOrders();

      for (final data in ordersWithItems) {
        try {
          final order = data['order'] as OrderModel;
          final items = data['items'] as List<OrderItemModel>;
          await _remote.createOrderRPC(order, items);
        } catch (e) {
          debugPrint('Error syncing order: $e');
          // Continue with next order
        }
      }
    } catch (e) {
      debugPrint('Error syncing orders: $e');
      rethrow;
    }
  }

  /// 📥 fetch all orders and update local database
  Future<void> fetchAllOrders() async {
    try {
      final ordersData = await _remote.getAllOrdersRPC();

      await _local.upsertOrdersFromRemote(
        ordersData['orders'] as List<OrderModel>,
        ordersData['items'] as List<OrderItemModel>,
      );
    } catch (e) {
      debugPrint('Error fetching all orders: $e');
    }
  }

  /// 👀 fetch order by ID from online DB
  Future<Map<String, dynamic>> fetchOrderByIdFromOnlineDB(int orderId) async {
    try {
      final result = await _remote.getOrderRPC(orderId);

      final order = result['order'] as OrderModel?;
      final items = result['items'] as List<OrderItemModel>;

      if (order != null) {
        order.synced = true;
        await _local.insertOrderWithItems(order, items);
      }

      return result;
    } catch (e) {
      debugPrint('Error fetching order from online DB: $e');
      rethrow;
    }
  }

  /// 🔄 sync order from Realtime payload
  Future<void> _syncOrderFromPayload(Map<String, dynamic> payload) async {
    try {
      final order = OrderModelJson.fromJson(payload);
      order.synced = true;
      await _local.updateOrder(order);
    } catch (e) {
      debugPrint('Error syncing order from payload: $e');
      rethrow;
    }
  }

  /// 🔄 sync order item from Realtime payload
  Future<void> _syncOrderItemFromPayload(Map<String, dynamic> payload) async {
    try {
      final orderItem = OrderItemModelJson.fromJson(payload);
      await _local.updateOrderItem(orderItem);
    } catch (e) {
      debugPrint('Error syncing order item from payload: $e');
      rethrow;
    }
  }

  /// ✏️ update order [status, total_price, address]
  Future<void> updateOrder(
    int orderId, {
    String? status,
    double? totalPrice,
    String? address,
  }) async {
    try {
      await _remote.updateOrder(
        orderId,
        status: status,
        totalPrice: totalPrice,
        address: address,
      );
    } catch (e) {
      debugPrint('Error updating order: $e');
      rethrow;
    }
  }

  /// ✏️ update order item [quantity]
  Future<void> updateOrderItem(int orderItemId, {int? quantity}) async {
    try {
      await _remote.updateOrderItem(orderItemId, quantity: quantity);
    } catch (e) {
      debugPrint('Error updating order item: $e');
      rethrow;
    }
  }

  /// 🗑️ delete order
  Future<void> deleteOrder(int orderId) async {
    try {
      await _remote.deleteOrder(orderId);
    } catch (e) {
      debugPrint('Error deleting order: $e');
      rethrow;
    }
  }

  /// 🗑️ delete order item
  Future<void> deleteOrderItem(int orderItemId) async {
    try {
      await _remote.deleteOrderItem(orderItemId);
    } catch (e) {
      debugPrint('Error deleting order item: $e');
      rethrow;
    }
  }

  /// 👀 watch orders for user
  Stream<List<Map<String, dynamic>>> watchOrders(String userId, String role) {
    try {
      return _local.watchOrders(userId, role);
    } catch (e) {
      debugPrint('Error watching orders: $e');
      rethrow;
    }
  }
}
