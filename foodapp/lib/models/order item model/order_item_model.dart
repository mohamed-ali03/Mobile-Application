import 'package:isar/isar.dart';

part 'order_item_model.g.dart';

@collection
class OrderItemModel {
  Id id = Isar.autoIncrement;

  @Index()
  late int orderId;
  @Index()
  late int itemId;
  late int quantity;
  late DateTime createdAt;
}
