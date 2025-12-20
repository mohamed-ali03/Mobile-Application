import 'package:flutter/rendering.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:foodapp/service/supabase_remote/supabase_service.dart';

class OrderRemoteService {
  /// Creates an order with associated items via RPC
  Future<Map<String, dynamic>> createOrderRPC(
    OrderModel order,
    List<OrderItemModel> items,
  ) async {
    final itemsJson = items
        .map(
          (item) => {
            'item_id': item.itemId,
            'quantity': item.quantity,
            'price': item.price,
          },
        )
        .toList();

    final response = await SupabaseService.client
        .rpc(
          'insert_order_with_items',
          params: {
            'p_user_id': order.userId,
            'p_total_price': order.totalPrice,
            'p_address': order.address,
            'p_status': 'pending',
            'p_created_at': order.createdAt?.toIso8601String(),
            'p_items': itemsJson,
          },
        )
        .single();

    return response;
  }

  /// Fetches a specific order with its items via RPC
  Future<Map<String, dynamic>> getOrderRPC(int orderId) async {
    try {
      final response = await SupabaseService.client
          .rpc('fetch_order_with_items', params: {'p_order_id': orderId})
          .single();

      // Check for error response
      if (response.containsKey('error')) {
        debugPrint('Order error: ${response['error']}');
        return {'order': null, 'items': []};
      }

      OrderModel order = _parseOrderFromResponse(response);
      List<OrderItemModel> items = _parseItemsFromResponse(response);

      return {'order': order, 'items': items};
    } catch (e) {
      debugPrint('Error fetching order: $e');
      return {'order': null, 'items': []};
    }
  }

  /// Fetches all orders with items via RPC
  Future<List<Map<String, dynamic>>> getAllOrdersRPC() async {
    try {
      final response = await SupabaseService.client.rpc('fetch_all_orders');

      if (response is Map) {
        final orders = response['orders'] as List<dynamic>?;

        if (orders == null || orders.isEmpty) {
          return [];
        }

        return orders.map((orderData) {
          final orderMap = orderData as Map<String, dynamic>;
          final order = _parseOrderFromResponse(orderMap);
          final items = _parseItemsFromResponse(orderMap);

          return {'order': order, 'items': items};
        }).toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error fetching all orders: $e');
      return [];
    }
  }

  /// Parse OrderModel from RPC response
  OrderModel _parseOrderFromResponse(Map<String, dynamic> response) {
    return OrderModel()
      ..orderId = response['id'] as int?
      ..userId = response['user_id'] as String
      ..status = response['status'] as String
      ..totalPrice = response['total_price'] as double
      ..address = response['address'] as String
      ..synced = true
      ..createdAt = response['created_at'] != null
          ? DateTime.parse(response['created_at'] as String)
          : null;
  }

  /// Parse OrderItemModel list from RPC response
  List<OrderItemModel> _parseItemsFromResponse(Map<String, dynamic> response) {
    final itemsList = <OrderItemModel>[];
    final items = response['items'];

    if (items is List) {
      for (final item in items) {
        final orderItem = OrderItemModel()
          ..orderId = response['id'] as int
          ..localOrderId =
              0 // Will be updated when synced locally
          ..orderItemId = item['item_id'] as int
          ..itemId = item['item_id'] as int
          ..quantity = item['quantity'] as int
          ..price = item['price'] as double;

        itemsList.add(orderItem);
      }
    }

    return itemsList;
  }
}
