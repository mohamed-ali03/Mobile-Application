import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:foodapp/service/repositories/order_repository.dart';
import 'package:isar/isar.dart';

class OrderProvider extends ChangeNotifier {
  final _repo = OrderRepository();

  bool isLoading = true;
  String? error;
  bool _isDisposed = false;

  List<OrderModel> orders = [];
  List<OrderItemModel> orderItems = [];

  late StreamSubscription _orderSub;
  late StreamSubscription _orderItemSub;

  OrderProvider(String? role) {
    _init(role);
    _orderSub = _repo.watchOrders().listen((orders) {
      this.orders = orders;
      notifyListeners();
    });

    _orderItemSub = _repo.watchOrderItems().listen((orderItems) {
      this.orderItems = orderItems;
      notifyListeners();
    });
  }

  Future<void> _init(String? role) async {
    try {
      _setError(null);
      // sync orders
      // await _repo.fetchAllOrders();

      // Start realtime AFTER init
      _repo.listenToOrderChanges(role ?? 'user');
      _repo.listenToOrderItemsChanges();

      _setLoading(false);
    } catch (e) {
      _setError('Failed to initialize orders: $e');
      debugPrint('Error initializing orders: $e');
      _setLoading(false);
    }
  }

  // clear all orders and order items (for logout)
  Future<void> clearAllData() async {
    try {
      _setError(null);
      _setLoading(true);
      await _repo.clearAllOrdersAndItems();
      _setLoading(false);
    } catch (e) {
      _setError('Failed to clear orders data: $e');
      debugPrint('Error clearing orders data: $e');
      _setLoading(false);
    }
  }

  //  =========================================================================================
  //                                           Order Item
  //  =========================================================================================
  // get Unsynced order items
  Future<List<OrderItemModel>> getUnsyncedOrderItems() async {
    return await _repo.getUnsyncedOrderItems();
  }

  /// add or update order item
  Future<void> upsertOrderItemLocally(OrderItemModel orderitem) async {
    try {
      _setError(null);
      _setLoading(true);
      await _repo.upsertOrderItem(orderitem);
      _setLoading(false);
    } catch (e) {
      _setError('Failed to add orderItem locally: $e');
      debugPrint('Error adding orderItem locally: $e');
      _setLoading(false);
    }
  }

  /// Update list of order items with (synced = false)
  Future<void> updateOrderItemsLocally(List<OrderItemModel> orderItems) async {
    try {
      if (orderItems.isEmpty) {
        debugPrint('No items to update');
        return;
      }

      await _repo.updateOrdersItem(orderItems);
    } catch (e) {
      debugPrint('Error updating orderItem locally: $e');
    }
  }

  // delete order item by id
  Future<void> deleteOrderItemLocally({Id? id, int? itemId}) async {
    try {
      _setError(null);
      _setLoading(true);
      await _repo.deleteOrderItem(id: id, itemId: itemId);
      _setLoading(false);
    } catch (e) {
      _setError('Failed to delete orderItem locally: $e');
      debugPrint('Error deleting orderItem locally: $e');
      _setLoading(false);
    }
  }

  //  =========================================================================================
  //                                          Order
  //  =========================================================================================
  /// 📥 Get all orders from the remote DB
  Future<void> fetchAllOrders() async {
    try {
      _setError(null);
      _setLoading(true);
      await _repo.fetchAllOrders();
      _setLoading(false);
    } catch (e) {
      _setError('Failed to fetch orders: $e');
      debugPrint('Error fetching orders: $e');
      _setLoading(false);
    }
  }

  /// ➕ Place an order (offline-first)
  Future<void> placeOrder(OrderModel order, List<OrderItemModel> items) async {
    try {
      _setError(null);
      _setLoading(true);
      await _repo.placeOrder(order, items);
      _setLoading(false);
    } catch (e) {
      _setError('Failed to place order: $e');
      debugPrint('Error placing order: $e');
      _setLoading(false);
    }
  }

  /// Delete order
  Future<void> deleteOrder(int orderId) async {
    try {
      _setError(null);
      _setLoading(true);
      await _repo.deleteOrder(orderId);
      _setLoading(false);
    } catch (e) {
      _setError('Failed to delete order: $e');
      debugPrint('Error Deleting order: $e');
      _setLoading(false);
    }
  }

  /// 🔄 Retry syncing unsynced orders
  Future<void> syncOrders() async {
    try {
      _setError(null);
      _setLoading(true);
      await _repo.syncOrders();
      _setLoading(false);
    } catch (e) {
      _setError('Failed to sync orders: $e');
      debugPrint('Error syncing orders: $e');
      _setLoading(false);
    }
  }

  /// update order
  Future<void> updateOrder(int orderId, String status) async {
    try {
      _setError(null);
      _setLoading(true);
      await _repo.updateOrder(orderId, status);
      _setLoading(false);
    } catch (e) {
      _setError('Failed to update orders: $e');
      debugPrint('Error Updating orders: $e');
      _setLoading(false);
    }
  }

  /// 🔧 Helper to safely set loading state
  void _setLoading(bool value) {
    if (!_isDisposed) {
      isLoading = value;
      notifyListeners();
    }
  }

  /// 🔧 Helper to safely set error state
  void _setError(String? value) {
    if (!_isDisposed) {
      error = value;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _repo.dispose();
    _orderItemSub.cancel();
    _orderSub.cancel();
    super.dispose();
  }
}
