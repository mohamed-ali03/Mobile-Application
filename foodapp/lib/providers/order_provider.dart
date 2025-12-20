import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:foodapp/service/repositories/order_repository.dart';

class OrderProvider extends ChangeNotifier {
  final _repo = OrderRepository();

  List<OrderModel> orders = [];
  Map<int, List<OrderItemModel>> orderItems = {};
  bool isLoading = true;
  String? error;

  StreamSubscription<List<Map<String, dynamic>>>? _ordersSub;

  OrderProvider(String userId) {
    _init(userId);
  }

  Future<void> _init(String userId) async {
    try {
      debugPrint('OrderProvider INIT for user: $userId');

      isLoading = true;
      notifyListeners();

      // Start realtime AFTER init
      _repo.listenToOrderChanges();
      _repo.listenToOrderItemsChanges();

      _ordersSub = _repo.watchOrders(userId).listen((updatedOrders) {
        _processOrdersData(updatedOrders);
        isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
    }
  }

  void _processOrdersData(List<Map<String, dynamic>> ordersData) {
    orders = [];
    orderItems = {};

    for (final data in ordersData) {
      final order = data['order'] as OrderModel;
      final items = data['items'] as List<OrderItemModel>;
      orders.add(order);
      orderItems[order.id] = items;
    }
  }

  /// ➕ Place an order (offline-first)
  Future<void> placeOrder(OrderModel order, List<OrderItemModel> items) async {
    try {
      await _repo.placeOrder(order, items);
    } catch (e) {
      error = 'Failed to place order: $e';
      debugPrint('Error placing order: $e');
      notifyListeners();
      rethrow;
    }
  }

  /// 🔄 Retry syncing unsynced orders
  Future<void> syncOrders() async {
    try {
      await _repo.syncOrders();
    } catch (e) {
      error = 'Failed to sync orders: $e';
      debugPrint('Error syncing orders: $e');
      notifyListeners();
      rethrow;
    }
  }

  /// Get order with its items
  Map<String, dynamic>? getOrderWithItems(int orderId) {
    final order = orders.firstWhere(
      (o) => o.id == orderId,
      orElse: () => null as dynamic,
    );

    return {'order': order, 'items': orderItems[orderId] ?? []};
  }

  @override
  void dispose() {
    _ordersSub?.cancel();
    super.dispose();
  }
}
