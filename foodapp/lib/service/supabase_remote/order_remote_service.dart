import 'package:flutter/material.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/models/order%20item%20model/order_item_parse.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:foodapp/models/order%20model/order_model_parse.dart';
import 'package:foodapp/service/supabase_remote/supabase_service.dart';

class OrderRemoteService {
  /// ➕ create order with associated items via RPC
  Future<Map<String, dynamic>> createOrderRPC(
    OrderModel order,
    List<OrderItemModel> items,
  ) async {
    try {
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
            'place_order',
            params: {
              'p_user_id': order.userId,
              'p_total_price': order.totalPrice,
              'p_address': order.address,
              'p_status': 'pending',
              'p_items': itemsJson,
            },
          )
          .single();

      order.orderId = response['id'];
      order.synced = true;
      order.createdAt = _parseDate(response['created_at']);
      for (int i = 0; i < items.length; i++) {
        items[i].orderItemId = response['items'][i]['id'];
        items[i].orderId = response['id'];
        items[i].synced = true;
        items[i].createdAt = _parseDate(response['items'][i]['created_at']);
      }
      return {'order': order, 'items': items};
    } catch (e) {
      debugPrint('Error creating order: $e');
      rethrow;
    }
  }

  /// 👀 fetch specific order with items via RPC
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

      final order = OrderModelJson.fromJson(response);
      final items =
          (response['items'] as List<dynamic>?)
              ?.map(
                (item) =>
                    OrderItemModelJson.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [];

      return {'order': order, 'items': items};
    } catch (e) {
      debugPrint('Error fetching order: $e');
      rethrow;
    }
  }

  /// ✏️ update order [status, total_price, address]
  Future<void> updateOrder(
    int orderId, {
    String? status,
    double? totalPrice,
    String? address,
    String? msg,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (status != null) data['status'] = status;
      if (totalPrice != null) data['total_price'] = totalPrice;
      if (address != null) data['address'] = address;
      if (msg != null) data['message'] = msg;

      if (data.isEmpty) return;

      await SupabaseService.client
          .from('orders')
          .update(data)
          .eq('id', orderId);
    } catch (e) {
      debugPrint('Error updating order: $e');
      rethrow;
    }
  }

  /// ✏️ update order item [quantity]
  Future<void> updateOrderItem(int orderItemId, {int? quantity}) async {
    try {
      if (quantity != null) {
        await SupabaseService.client
            .from('orderItems')
            .update({'quantity': quantity})
            .eq('id', orderItemId);
      }
    } catch (e) {
      debugPrint('Error updating order item: $e');
      rethrow;
    }
  }

  /// 🗑️ delete order (cascade deletes items via RPC)
  Future<Map<String, dynamic>> deleteOrder(int orderId) async {
    try {
      final response = await SupabaseService.client
          .rpc('delete_order', params: {'p_order_id': orderId})
          .single();

      return response;
    } catch (e) {
      debugPrint('Error deleting order: $e');
      rethrow;
    }
  }

  /// 🗑️ delete order item
  Future<void> deleteOrderItem(int orderItemId) async {
    try {
      await SupabaseService.client
          .from('orderItems')
          .delete()
          .eq('id', orderItemId);
    } catch (e) {
      debugPrint('Error deleting order item: $e');
      rethrow;
    }
  }

  /// 👀 fetch all orders with items via RPC
  Future<Map<String, dynamic>> getAllOrdersRPC() async {
    try {
      final response = await SupabaseService.client.rpc('fetch_all_orders');

      if (response['orders'] is! List<dynamic>) {
        debugPrint('Invalid response type: ${response.runtimeType}');
        return {'orders': [], 'items': []};
      }

      final allOrders = <OrderModel>[];
      final allItems = <OrderItemModel>[];

      // Process each order
      for (final orderData in response['orders']) {
        try {
          final orderMap = orderData as Map<String, dynamic>;
          final order = OrderModelJson.fromJson(orderMap);

          final itemsList = orderMap['items'] as List<dynamic>? ?? [];
          final items = itemsList
              .map(
                (item) =>
                    OrderItemModelJson.fromJson(item as Map<String, dynamic>),
              )
              .toList();

          allOrders.add(order);
          allItems.addAll(items);
        } catch (e) {
          debugPrint('Error parsing order: $e');
          continue; // Skip this order and continue
        }
      }

      return {'orders': allOrders, 'items': allItems};
    } catch (e) {
      debugPrint('Error fetching all orders: $e');
      rethrow;
    }
  }
}

/// 🔧 helper to safely parse dates
DateTime? _parseDate(dynamic date) {
  if (date == null) return null;
  try {
    return DateTime.parse(date.toString());
  } catch (e) {
    debugPrint('Date parse error: $e');
    return null;
  }
}
