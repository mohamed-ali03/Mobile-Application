import 'package:isar/isar.dart';
import 'package:restaurant/feature/local_database/order/order_item_entity.dart';

part 'order_entity.g.dart';

@collection
class OrderEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String orderId;
  @Index(unique: true)
  late String userId;
  late String status;
  late double totalPrice;
  late String? address;
  late List<OrderItemEntity> items;
  late DateTime createdAt;
  late DateTime updatedAt;
}
