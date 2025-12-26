import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:foodapp/service/repositories/order_repository.dart';
import 'package:isar/isar.dart';
import 'package:rxdart/rxdart.dart';

class OrderProvider extends ChangeNotifier {
  final _repo = OrderRepository();

  bool isLoading = true;
  String? error;
  bool _isDisposed = false;

  Stream<Map<String, dynamic>> get ordersWithItemsSub =>
      Rx.combineLatest2<
        List<OrderModel>,
        List<OrderItemModel>,
        Map<String, dynamic>
      >(ordersSub, orderItemsSub, (orders, items) {
        return {'orders': orders, 'items': items};
      });

  OrderProvider(String role) {
    _init(role);
  }

  Future<void> _init(String role) async {
    try {
      _setError(null);
      // sync orders
      await _repo.fetchAllOrders();

      // Start realtime AFTER init
      _repo.listenToOrderChanges(role);
      _repo.listenToOrderItemsChanges();

      _setLoading(false);
    } catch (e) {
      _setError('Failed to initialize orders: $e');
      debugPrint('Error initializing orders: $e');
      _setLoading(false);
    }
  }

  //  =========================================================================================
  //                                           Order Item
  //  =========================================================================================

  // watch order Items
  Stream<List<OrderItemModel>> get orderItemsSub => _repo.watchOrderItems();

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

  // delete order item by id
  Future<void> deleteOrderItemLocally(Id id) async {
    try {
      _setError(null);
      _setLoading(true);
      await _repo.deleteOrderItem(id);
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
  // watch orders
  Stream<List<OrderModel>> get ordersSub => _repo.watchOrders();

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
    super.dispose();
  }
}
