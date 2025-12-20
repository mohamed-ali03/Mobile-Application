import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:foodapp/service/isar_local/order_local_service.dart';
import 'package:foodapp/service/supabase_remote/order_remote_service.dart';
import 'package:foodapp/service/supabase_remote/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRepository {
  final _local = OrderLocalService();
  final _remote = OrderRemoteService();

  void listenToOrderChanges() {
    SupabaseService.client
        .channel('public:orders')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'orders',
          callback: (payload) {
            fetchOrderByIdFromOnlineDB(payload.newRecord['id']);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'orders',
          callback: (payload) {
            _syncOrderFromPayload(payload.newRecord);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'orders',
          callback: (payload) {
            _local.deleteOrder(payload.newRecord['id'] as int);
          },
        )
        .subscribe();
  }

  // OrderItems table subscription
  void listenToOrderItemsChanges() {
    SupabaseService.client
        .channel('public:orderItems')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'orderItems',
          callback: (payload) {
            _syncOrderItemFromPayload(payload.newRecord);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'orderItems',
          callback: (payload) {
            _local.deleteOrderItem(payload.oldRecord['id']);
          },
        )
        .subscribe();
  }

  /// ➕ place order (offline-first)
  Future<void> placeOrder(OrderModel order, List<OrderItemModel> items) async {
    order.synced = false;

    final localOrderId = await _local.insertOrderWithItems(order, items);

    try {
      final res = await _remote.createOrderRPC(order, items);

      await _local.markOrderSynced(localOrderId, res['id'], res['status']);
    } catch (_) {
      // offline → keep local
    }
  }

  /// 🔄 retry unsynced orders
  Future<void> syncOrders() async {
    final ordersWithItems = await _local.getUnsyncedOrders();

    for (final data in ordersWithItems) {
      try {
        final order = data['order'] as OrderModel;
        final items = data['items'] as List<OrderItemModel>;

        final res = await _remote.createOrderRPC(order, items);

        await _local.markOrderSynced(order.id, res['id'], res['status']);
      } catch (_) {}
    }
  }

  /// Fetch order by ID from online DB
  Future<void> fetchOrderByIdFromOnlineDB(int orderId) async {
    try {
      final result = await _remote.getOrderRPC(orderId);

      final order = result['order'] as OrderModel?;
      final items = result['items'] as List<OrderItemModel>;

      if (order != null) {
        order.synced = true;
        await _local.insertOrderWithItems(order, items);
      }
    } catch (e) {
      debugPrint('Error fetching order from online DB: $e');
    }
  }

  /// Sync order from Realtime payload
  Future<void> _syncOrderFromPayload(Map<String, dynamic> payload) async {
    try {
      final order = OrderModel()
        ..orderId = payload['id'] as int?
        ..userId = payload['user_id'] as String
        ..status = payload['status'] as String
        ..totalPrice = payload['total_price'] as double
        ..address = payload['address'] as String
        ..synced = true
        ..createdAt = payload['created_at'] != null
            ? DateTime.parse(payload['created_at'] as String)
            : null;

      await _local.addOrUpdateOrderOnly(order);
    } catch (e) {
      debugPrint('Error syncing order from payload: $e');
    }
  }

  /// Sync order item from Realtime payload
  Future<void> _syncOrderItemFromPayload(Map<String, dynamic> payload) async {
    try {
      final orderItem = OrderItemModel()
        ..orderId = payload['order_id'] as int?
        ..orderItemId = payload['id'] as int
        ..itemId = payload['item_id'] as int
        ..quantity = payload['quantity'] as int
        ..price = payload['price'] as double;

      await _local.addOrUpdateOrderItemOnly(orderItem);
    } catch (e) {
      debugPrint('Error syncing order item from payload: $e');
    }
  }

  /// 👀 UI
  Stream<List<Map<String, dynamic>>> watchOrders(String userId) =>
      _local.watchOrders(userId);
}
