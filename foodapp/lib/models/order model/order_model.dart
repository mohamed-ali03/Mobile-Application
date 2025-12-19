import 'package:isar/isar.dart';

part 'order_model.g.dart';

@collection
class OrderModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late int orderId;
  @Index()
  late String userID;
  late String status;
  late double totalPrice;
  late String address;
  late DateTime createdAt;
}
