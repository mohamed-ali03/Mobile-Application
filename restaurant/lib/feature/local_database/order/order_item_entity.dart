import 'package:isar/isar.dart';

part 'order_item_entity.g.dart';

@embedded
class OrderItemEntity {
  late String itemId;
  late String name;
  late double price;
  late int qty;
}
