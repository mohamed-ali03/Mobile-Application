// ============================================================================
// Delivered Orders Tab View
// ============================================================================
import 'package:flutter/material.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:foodapp/widgets/order_card.dart';

class DeliveredOrdersTabView extends StatelessWidget {
  final List<OrderModel> orders;
  final Function(String) onGetStatusColor;
  final Function(dynamic) onFormatDate;

  const DeliveredOrdersTabView({
    super.key,
    required this.orders,
    required this.onGetStatusColor,
    required this.onFormatDate,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(child: Text('No delivered orders'));
    }

    return ListView.builder(
      itemCount: orders.length,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) => OrderCard(
        order: orders[index],
        onGetStatusColor: onGetStatusColor,
        onFormatDate: onFormatDate,
      ),
    );
  }
}
