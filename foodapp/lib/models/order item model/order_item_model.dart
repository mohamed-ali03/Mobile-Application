import 'package:isar/isar.dart';

part 'order_item_model.g.dart';

@collection
class OrderItemModel {
  Id id = Isar.autoIncrement;

  int? orderId; // remote order id (after sync)
  int? localOrderId; // 🔑 Isar OrderModel.id
  int? orderItemId;

  late int itemId; // menu item remote id
  late int quantity;
  late double price;
  late bool synced;
}
