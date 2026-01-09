import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/models/order%20item%20model/order_item_parse.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:foodapp/models/order%20model/order_model_parse.dart';
import 'package:foodapp/service/isar_local/order_local_service.dart';
import 'package:foodapp/service/supabase_remote/order_remote_service.dart';
import 'package:foodapp/service/supabase_remote/supabase_service.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRepository {
  final _local = OrderLocalService();
  final _remote = OrderRemoteService();

  // Store subscriptions for cleanup
  RealtimeChannel? _ordersChannel;
  RealtimeChannel? _orderItemsChannel;

  // clear all local orders and items (for logout)
  Future<void> clearAllOrdersAndItems() async {
    try {
      await _local.clearAllOrdersAndItems();
    } catch (e) {
      debugPrint('Error clearing local orders and items: $e');
      rethrow;
    }
  }

  // ====================================================================================================
  //                                        Order Item
  // ====================================================================================================

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
              _local
                  .deleteOrderItem(orderItemId: payload.oldRecord['id'] as int)
                  .catchError((e) {
                    debugPrint('Error syncing deleted order item: $e');
                  });
            },
          )
          .subscribe();
    } catch (e) {
      debugPrint('Error setting up order items listener: $e');
      rethrow;
    }
  }

  /// 🔄 sync order item from Realtime payload
  Future<void> _syncOrderItemFromPayload(Map<String, dynamic> payload) async {
    try {
      final orderItem = OrderItemModelJson.fromJson(payload);
      orderItem.synced = true;
      await _local.upsertOrderItem(orderItem);
    } catch (e) {
      debugPrint('Error syncing order item from payload: $e');
      rethrow;
    }
  }

  /// 👀 watch order items for user
  Stream<List<OrderItemModel>> watchOrderItems() {
    try {
      return _local.watchOrderItems();
    } catch (e) {
      debugPrint('Error watching orders: $e');
      rethrow;
    }
  }

  /// add/update item
  Future<void> upsertOrderItem(OrderItemModel orderitem) async {
    try {
      orderitem.synced = false;
      await _local.upsertOrderItem(orderitem);
    } catch (e) {
      debugPrint('Error placing order: $e');
      rethrow;
    }
  }

  /// update list of order items
  Future<void> updateOrdersItem(List<OrderItemModel> orderitems) async {
    try {
      await _local.updateOrdersItem(orderitems);
    } catch (e) {
      debugPrint('Error placing order: $e');
      rethrow;
    }
  }

  /// delete orderitem
  Future<void> deleteOrderItem({Id? id, int? itemId}) async {
    try {
      await _local.deleteOrderItem(id: id, itemId: itemId);
    } catch (e) {
      debugPrint('Error Deleting local orderItem: $e');
      rethrow;
    }
  }

  /// get unsynced orderitems
  Future<List<OrderItemModel>> getUnsyncedOrderItems() async {
    return await _local.getUnsyncedOrderItems();
  }

  // ====================================================================================================
  //                                           Order
  // ====================================================================================================

  /// 🔔 listen to changes in order table [insert, update, delete]
  void listenToOrderChanges(String role) {
    try {
      _ordersChannel = SupabaseService.client
          .channel('public:orders')
          .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'orders',
            callback: (payload) {
              if (role != 'user') {
                _fetchOrderByIdFromOnlineDB(
                  payload.newRecord['id'] as int,
                  // ignore: body_might_complete_normally_catch_error
                ).catchError((e) {
                  debugPrint('Error syncing inserted order: $e');
                });
              }
            },
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'orders',
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

  /// 👀 fetch order by ID from online DB
  Future<Map<String, dynamic>> _fetchOrderByIdFromOnlineDB(int orderId) async {
    try {
      final result = await _remote.getOrderRPC(orderId);

      final order = result['order'] as OrderModel?;
      final items = result['items'] as List<OrderItemModel>;

      if (order != null) {
        order.synced = true;
        for (final item in items) {
          item.synced = true;
        }
        await _local.upsertOrder(order, items);
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
      await _local.upsertOrder(order, []);
    } catch (e) {
      debugPrint('Error syncing order from payload: $e');
      rethrow;
    }
  }

  /// 👀 watch orders for user
  Stream<List<OrderModel>> watchOrders() {
    try {
      return _local.watchOrders();
    } catch (e) {
      debugPrint('Error watching orders: $e');
      rethrow;
    }
  }

  /// 📥 fetch all orders and update local database
  Future<void> fetchAllOrders() async {
    try {
      final ordersData = await _remote.getAllOrdersRPC();

      await _local.upsertOrders(
        ordersData['orders'] as List<OrderModel>,
        ordersData['items'] as List<OrderItemModel>,
      );
    } catch (e) {
      debugPrint('Error fetching all orders: $e');
    }
  }

  /// ➕ place order (offline-first)
  Future<void> placeOrder(OrderModel order, List<OrderItemModel> items) async {
    try {
      order.synced = false;
      for (var item in items) {
        item.synced = true;
      }
      await _local.upsertOrder(order, items);

      try {
        final response = await _remote.createOrderRPC(order, items);

        await _local.upsertOrder(response['order'], response['items']);
      } catch (e) {
        debugPrint('Error placing order remotely (will retry): $e');
      }
    } catch (e) {
      debugPrint('Error placing order: $e');
      rethrow;
    }
  }

  Future<void> updateOrder(int orderId, String status) async {
    try {
      await _remote.updateOrder(orderId, status: status);
    } catch (e) {
      debugPrint('Error Deleting order: $e');
      rethrow;
    }
  }

  /// delete Order
  Future<void> deleteOrder(int orderId) async {
    try {
      await _remote.deleteOrder(orderId);
    } catch (e) {
      debugPrint('Error Deleting order: $e');
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
          final response = await _remote.createOrderRPC(order, items);
          await _local.upsertOrder(response['order'], response['items']);
        } catch (e) {
          debugPrint('Error syncing order: $e');
        }
      }
    } catch (e) {
      debugPrint('Error syncing orders: $e');
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
}
