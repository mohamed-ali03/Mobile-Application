import 'package:flutter/material.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:foodapp/service/isar_local/isar_service.dart';
import 'package:isar/isar.dart';

class OrderLocalService {
  // =================================================================================================
  //                                         Order Item CRUD
  // =================================================================================================

  /// 🔍 watch all order items
  Stream<List<OrderItemModel>> watchOrderItems() {
    return IsarService.isar.orderItemModels.where().watch(
      fireImmediately: true,
    );
  }

  /// get unsynced order items
  Future<List<OrderItemModel>> getUnsyncedOrderItems() async {
    return await IsarService.isar.orderItemModels
        .filter()
        .syncedEqualTo(false)
        .findAll();
  }

  /// create/Update order item
  Future<void> upsertOrderItem(OrderItemModel orderItem) async {
    try {
      await IsarService.isar.writeTxn(() async {
        await _upsertOrderItem(orderItem);
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  /// Update list of order item
  Future<void> updateOrdersItem(List<OrderItemModel> orderItems) async {
    try {
      await IsarService.isar.writeTxn(() async {
        for (final orderItem in orderItems) {
          await IsarService.isar.orderItemModels.put(orderItem);
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  /// 🗑️ delete a single order item using remote id
  Future<void> deleteOrderItem({Id? id, int? orderItemId, int? itemId}) async {
    try {
      await IsarService.isar.writeTxn(() async {
        if (id != null) {
          await IsarService.isar.orderItemModels.delete(id);
        } else if (orderItemId != null) {
          await IsarService.isar.orderItemModels
              .filter()
              .orderItemIdEqualTo(orderItemId)
              .deleteFirst();
        } else if (itemId != null) {
          await IsarService.isar.orderItemModels
              .filter()
              .itemIdEqualTo(itemId)
              .deleteFirst();
        }
      });
    } catch (e) {
      debugPrint('Error deleting order item: $e');
      rethrow;
    }
  }

  /// ➕ insert or update order item
  Future<int> _upsertOrderItem(OrderItemModel orderItem) async {
    try {
      if (orderItem.orderItemId == null) {
        final existing = await IsarService.isar.orderItemModels
            .filter()
            .itemIdEqualTo(orderItem.itemId)
            .findFirst();
        if (existing != null) {
          orderItem.id = existing.id;
        }
        return await IsarService.isar.orderItemModels.put(orderItem);
      } else {
        final existing = await IsarService.isar.orderItemModels
            .filter()
            .orderItemIdEqualTo(orderItem.orderItemId)
            .findFirst();

        if (existing != null) {
          orderItem.id = existing.id;
          return await IsarService.isar.orderItemModels.put(orderItem);
        } else {
          return await IsarService.isar.orderItemModels.put(orderItem);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  // =================================================================================================
  //                                          Order CRUD
  // =================================================================================================

  /// 👀 UI: order list with items
  Stream<List<OrderModel>> watchOrders() {
    try {
      return IsarService.isar.orderModels.where().sortByCreatedAtDesc().watch(
        fireImmediately: true,
      );
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

  /// ➕ upsert order
  Future<int> upsertOrder(OrderModel order, List<OrderItemModel> items) async {
    try {
      late int orderLocalId;

      await IsarService.isar.writeTxn(() async {
        orderLocalId = await _upsertOrder(order);

        for (final item in items) {
          item.localOrderId = orderLocalId;
          await _upsertOrderItem(item);
        }
      });

      return orderLocalId;
    } catch (e) {
      debugPrint('Error inserting order with items: $e');
      rethrow;
    }
  }

  /// 📝 upsert orders and items from remote
  Future<void> upsertOrders(
    List<OrderModel> orders,
    List<OrderItemModel> items,
  ) async {
    try {
      await IsarService.isar.writeTxn(() async {
        for (final order in orders) {
          final localOrderId = await _upsertOrder(order);

          final orderItems = items
              .where((item) => item.orderId == order.orderId)
              .toList();

          for (final item in orderItems) {
            item.localOrderId = localOrderId;
            await _upsertOrderItem(item);
          }
        }
      });
    } catch (e) {
      debugPrint('Error upserting orders from remote: $e');
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

  Future<void> clearMenu() async {
    try {
      await IsarService.isar.writeTxn(() async {
        await IsarService.isar.orderItemModels.clear();
        await IsarService.isar.orderModels.clear();
      });
    } catch (_) {}
  }

  /// ➕ insert or update order only (no items)
  Future<int> _upsertOrder(OrderModel order) async {
    if (order.orderId == null) {
      return await IsarService.isar.orderModels.put(order);
    } else {
      final existing = await IsarService.isar.orderModels
          .filter()
          .orderIdEqualTo(order.orderId)
          .findFirst();

      if (existing != null) {
        order.id = existing.id;
        return await IsarService.isar.orderModels.put(order);
      } else {
        return await IsarService.isar.orderModels.put(order);
      }
    }
  }
}
