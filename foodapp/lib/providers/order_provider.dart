import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:foodapp/models/user%20model/user_model.dart';
import 'package:foodapp/service/repositories/order_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderProvider extends ChangeNotifier {
  final _repo = OrderRepository();

  bool isLoading = true;
  String? error;
  bool _isDisposed = false;

  Stream<List<Map<String, dynamic>>>? ordersSub;

  OrderProvider(UserModel? user) {
    if (user == null) return;
    _init(user.authID, user.role);
  }

  Future<void> _init(String userId, String role) async {
    try {
      _setError(null);

      if (role == 'user') {
        _repo.filter = PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'user_id',
          value: userId,
        );
      }

      // sync orders
      await _repo.fetchAllOrders();

      // Start realtime AFTER init
      _repo.listenToOrderChanges();
      _repo.listenToOrderItemsChanges();

      ordersSub = _repo.watchOrders(userId, role);

      _setLoading(false);
    } catch (e) {
      _setError('Failed to initialize orders: $e');
      debugPrint('Error initializing orders: $e');
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

  /// 👀 Get order with its items
  Future<Map<String, dynamic>> getOrderWithItems(int orderId) async {
    try {
      _setError(null);
      _setLoading(true);
      final order = await _repo.fetchOrderByIdFromOnlineDB(orderId);
      _setLoading(false);
      return order;
    } catch (e) {
      _setError('Failed to fetch order: $e');
      debugPrint('Error fetching order: $e');
      _setLoading(false);
      return {};
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
