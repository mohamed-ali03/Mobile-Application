import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:foodapp/service/isar_local/isar_service.dart';
import 'package:isar/isar.dart';

class OrderLocalService {
  /// ➕ create order + items atomically
  Future<int> insertOrderWithItems(
    OrderModel order,
    List<OrderItemModel> items,
  ) async {
    late int orderLocalId;

    await IsarService.isar.writeTxn(() async {
      orderLocalId = await addOrUpdateOrderOnly(order);

      for (final item in items) {
        item.localOrderId = orderLocalId;
        await IsarService.isar.orderItemModels.put(item);
      }
    });

    return orderLocalId;
  }

  /// ➕ Insert or update order ONLY (no items)
  Future<int> addOrUpdateOrderOnly(OrderModel order) async {
    late int localId;

    await IsarService.isar.writeTxn(() async {
      final existing = await IsarService.isar.orderModels
          .filter()
          .orderIdEqualTo(order.orderId)
          .findFirst();

      if (existing != null) {
        order.id = existing.id;
      }

      localId = await IsarService.isar.orderModels.put(order);
    });

    return localId;
  }

  /// ➕ Insert or update order ONLY (no items)
  Future<int> addOrUpdateOrderItemOnly(OrderItemModel orderItem) async {
    late int localId;

    await IsarService.isar.writeTxn(() async {
      final existing = await IsarService.isar.orderItemModels
          .filter()
          .orderItemIdEqualTo(orderItem.orderItemId)
          .findFirst();

      if (existing != null) {
        orderItem.id = existing.id;
      }

      localId = await IsarService.isar.orderItemModels.put(orderItem);
    });

    return localId;
  }

  /// 🗑 Delete entire order + all its items
  Future<void> deleteOrder(int remoteId) async {
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
  }

  /// 🗑 Delete a single order item
  Future<void> deleteOrderItem(int itemId) async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.orderItemModels.delete(itemId);
    });
  }

  /// 👀 UI: order list with items
  Stream<List<Map<String, dynamic>>> watchOrders(String userId) async* {
    final orderStream = IsarService.isar.orderModels
        .filter()
        .userIdEqualTo(userId)
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true);

    await for (final orders in orderStream) {
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
  }

  /// 🔍 unsynced orders with items
  Future<List<Map<String, dynamic>>> getUnsyncedOrders() async {
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
  }

  /// 🔄 mark order
  Future<void> markOrderSynced(
    int localOrderId,
    int remoteOrderId,
    String status,
  ) async {
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
  }
}
