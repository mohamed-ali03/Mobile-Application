import 'order_model.dart';

extension OrderModelJson on OrderModel {
  /// Convert OrderModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': orderId,
      'user_id': userId,
      'status': status,
      'total_price': totalPrice,
      'address': address,
    };
  }

  /// Create OrderModel from JSON
  static OrderModel fromJson(Map<String, dynamic> json) {
    return OrderModel()
      ..orderId = json['id'] as int?
      ..userId = json['user_id'] as String
      ..status = json['status'] as String
      ..totalPrice = (json['total_price'] as num).toDouble()
      ..address = json['address'] as String
      ..createdAt = json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null;
  }
}
