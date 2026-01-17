import 'package:flutter/material.dart';
import 'package:foodapp/l10n/app_localizations.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:foodapp/screens/widgets/order_card.dart';

class AdminOrderTabView extends StatelessWidget {
  final List<OrderModel> orders;
  final List<OrderItemModel> orderItems;

  const AdminOrderTabView({
    required this.orders,
    required this.orderItems,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(AppLocalizations.of(context).t('noOrdersYet')),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) => OrderCard(
        order: orders[index],
        orderItems: orderItems
            .where((item) => item.orderId == orders[index].orderId)
            .toList(),
      ),
    );
  }
}
