import 'package:restaurant/feature/local_database/order/order_entity.dart';
import 'package:restaurant/feature/local_database/order/order_item_entity.dart';
import 'package:restaurant/feature/models/order_item.dart';
import 'package:restaurant/feature/models/order_model.dart';

extension OrderMapper on OrderModel {
  OrderEntity toEntity() {
    return OrderEntity()
      ..orderId = orderId
      ..userId = userId
      ..status = status
      ..totalPrice = totalPrice
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..items = items.map((e) {
        return OrderItemEntity()
          ..itemId = e.itemId
          ..name = e.name
          ..price = e.price
          ..qty = e.qty;
      }).toList();
  }
}

extension OrderEntityMapper on OrderEntity {
  OrderModel toEntity() {
    return OrderModel(
      orderId: orderId,
      userId: userId,
      status: status,
      totalPrice: totalPrice,
      items: items.map((item) {
        return OrderItem(
          itemId: item.itemId,
          name: item.name,
          price: item.price,
          qty: item.qty,
        );
      }).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
