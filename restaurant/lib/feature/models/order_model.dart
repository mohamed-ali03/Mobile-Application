import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant/feature/models/order_item.dart';

class OrderModel {
  String orderId;
  String userId;

  String status; // pending, accepted, preparing, done, cancelled

  double totalPrice;

  String? address;

  List<OrderItem> items;

  DateTime createdAt;
  DateTime updatedAt;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.status,
    required this.totalPrice,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
    this.address,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'status': status,
    'totalPrice': totalPrice,
    'address': address,
    'items': items.map((e) => e.toMap()).toList(),
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  factory OrderModel.fromJson(Map<String, dynamic> json, String docId) {
    return OrderModel(
      orderId: docId,
      userId: json['userId'],
      status: json['status'],
      totalPrice: (json['totalPrice'] as num).toDouble(),
      address: json['address'],
      items: (json['items'] as List).map((e) => OrderItem.fromJson(e)).toList(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }
}
