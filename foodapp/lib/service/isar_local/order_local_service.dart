import 'package:flutter/material.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:foodapp/service/isar_local/isar_service.dart';
import 'package:isar/isar.dart';

class OrderLocalService {
  /// 📝 upsert orders and items from remote
  Future<void> upsertOrdersFromRemote(
    List<OrderModel> orders,
    List<OrderItemModel> items,
  ) async {
    try {
      await IsarService.isar.writeTxn(() async {
        for (final order in orders) {
          order.synced = true;
          final localOrderId = await _addOrUpdateOrderOnly(order);

          final orderItems = items
              .where((item) => item.orderId == order.orderId)
              .toList();

          for (final item in orderItems) {
            item.localOrderId = localOrderId;
            await _addOrUpdateOrderItemOnly(item);
          }
        }
      });
    } catch (e) {
      debugPrint('Error upserting orders from remote: $e');
      rethrow;
    }
  }

  /// ➕ insert order + items atomically
  Future<int> insertOrderWithItems(
    OrderModel order,
    List<OrderItemModel> items,
  ) async {
    try {
      late int orderLocalId;

      await IsarService.isar.writeTxn(() async {
        orderLocalId = await _addOrUpdateOrderOnly(order);

        for (final item in items) {
          item.localOrderId = orderLocalId;
          await _addOrUpdateOrderItemOnly(item);
        }
      });

      return orderLocalId;
    } catch (e) {
      debugPrint('Error inserting order with items: $e');
      rethrow;
    }
  }

  /// ➕ insert or update order only (no items)
  Future<int> _addOrUpdateOrderOnly(OrderModel order) async {
    final existing = await IsarService.isar.orderModels
        .filter()
        .orderIdEqualTo(order.orderId)
        .findFirst();

    if (existing != null) {
      order.id = existing.id;
    }

    return await IsarService.isar.orderModels.put(order);
  }

  /// ✏️ update order
  Future<void> updateOrder(OrderModel order) async {
    try {
      await IsarService.isar.writeTxn(() async {
        await _addOrUpdateOrderOnly(order);
      });
    } catch (e) {
      debugPrint('Error updating order: $e');
      rethrow;
    }
  }

  /// ➕ insert or update order item only
  Future<int> _addOrUpdateOrderItemOnly(OrderItemModel orderItem) async {
    final existing = await IsarService.isar.orderItemModels
        .filter()
        .orderItemIdEqualTo(orderItem.orderItemId)
        .findFirst();

    if (existing != null) {
      orderItem.id = existing.id;
    }

    return await IsarService.isar.orderItemModels.put(orderItem);
  }

  /// ✏️ update order item
  Future<void> updateOrderItem(OrderItemModel orderItem) async {
    try {
      await IsarService.isar.writeTxn(() async {
        await _addOrUpdateOrderItemOnly(orderItem);
      });
    } catch (e) {
      debugPrint('Error updating order item: $e');
      rethrow;
    }
  }

  /// 🗑️ delete entire order + all its items
  Future<void> deleteOrder(int remoteId) async {
    try {
      await IsarService.isar.writeTxn(() async {
        final existing = await IsarService.isar.orderModels
            .filter()
            .orderIdEqualTo(remoteId)
            .findFirst();

        if (existing != null) {
          // Delete items first
          await IsarService.isar.orderItemModels
              .filter()
              .localOrderIdEqualTo(existing.id)
              .deleteAll();
          // Then delete the order
          await IsarService.isar.orderModels.delete(existing.id);
        }
      });
    } catch (e) {
      debugPrint('Error deleting order: $e');
      rethrow;
    }
  }

  /// 🗑️ delete a single order item
  Future<void> deleteOrderItem(int itemId) async {
    try {
      await IsarService.isar.writeTxn(() async {
        await IsarService.isar.orderItemModels.delete(itemId);
      });
    } catch (e) {
      debugPrint('Error deleting order item: $e');
      rethrow;
    }
  }

  /// 👀 UI: order list with items
  Stream<List<Map<String, dynamic>>> watchOrders(
    String userId,
    String role,
  ) async* {
    try {
      late final Stream<List<OrderModel>> orderStream;
      if (role == 'user') {
        orderStream = IsarService.isar.orderModels
            .filter()
            .userIdEqualTo(userId)
            .sortByCreatedAtDesc()
            .watch(fireImmediately: true);
      } else {
        orderStream = IsarService.isar.orderModels
            .where()
            .sortByCreatedAtDesc()
            .watch(fireImmediately: true);
      }

      await for (final orders in orderStream) {
        if (orders.isEmpty) {
          yield [];
          continue;
        }
        final result = <Map<String, dynamic>>[];

        for (final order in orders) {
          final items = await IsarService.isar.orderItemModels
              .filter()
              .localOrderIdEqualTo(order.id)
              .findAll();

          result.add({'order': order, 'items': items});
        }

        yield result;
      }
    } catch (e) {
      debugPrint('Error watching orders: $e');
      rethrow;
    }
  }

  /// 🔍 unsynced orders with items
  Future<List<Map<String, dynamic>>> getUnsyncedOrders() async {
    try {
      final orders = await IsarService.isar.orderModels
          .filter()
          .syncedEqualTo(false)
          .findAll();

      final result = <Map<String, dynamic>>[];

      for (final order in orders) {
        final items = await IsarService.isar.orderItemModels
            .filter()
            .localOrderIdEqualTo(order.id)
            .findAll();

        result.add({'order': order, 'items': items});
      }

      return result;
    } catch (e) {
      debugPrint('Error getting unsynced orders: $e');
      rethrow;
    }
  }

  /// 🔄 mark order
  Future<void> markOrderSynced(
    int localOrderId,
    int remoteOrderId,
    String status,
  ) async {
    try {
      await IsarService.isar.writeTxn(() async {
        final order = await IsarService.isar.orderModels.get(localOrderId);
        if (order == null) return;

        order
          ..orderId = remoteOrderId
          ..status = status
          ..synced = true;

        await IsarService.isar.orderModels.put(order);

        final items = await IsarService.isar.orderItemModels
            .filter()
            .localOrderIdEqualTo(localOrderId)
            .findAll();

        for (final item in items) {
          item.orderId = remoteOrderId;
          await IsarService.isar.orderItemModels.put(item);
        }
      });
    } catch (e) {
      debugPrint('Error marking order synced: $e');
      rethrow;
    }
  }
}
