import 'package:flutter/material.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:foodapp/providers/order_provider.dart';
import 'package:foodapp/screens/user/widgets/order_item_card.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class UnsyncedItems extends StatefulWidget {
  List<OrderItemModel> orderItems;

  UnsyncedItems({super.key, required this.orderItems});

  @override
  State<UnsyncedItems> createState() => _UnsyncedItemsState();
}

class _UnsyncedItemsState extends State<UnsyncedItems> {
  late ValueNotifier<double> totalPrice = ValueNotifier(0);

  bool isChanged = false;

  @override
  void dispose() {
    if (isChanged) {
      context.read<OrderProvider>().updateOrderItemsLocally(widget.orderItems);
    }
    totalPrice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _calculateTotal();
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8),
            itemCount: widget.orderItems.length,
            itemBuilder: (context, index) => OrderItemCard(
              orderItem: widget.orderItems[index],
              onChangeQty: (qty) {
                widget.orderItems[index].quantity = qty;
                _calculateTotal();
                isChanged = true;
              },
              onDeleteOrderItem: () => _onDeleteItem(index, context),
            ),
          ),
        ),
        _buildCheckoutSection(),
      ],
    );
  }

  void _calculateTotal() {
    double temp = 0;
    for (final item in widget.orderItems) {
      temp += item.price * item.quantity;
    }
    totalPrice.value = temp;
  }

  void _onDeleteItem(int index, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Order'),
        content: Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<OrderProvider>().deleteOrderItemLocally(
                id: widget.orderItems[index].id,
              );
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _handleCheckout() async {
    final authProvider = context.read<AuthProvider>();

    if (authProvider.user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please login to continue')));
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Checkout'),
        content: Text('Are you sure you want to checkout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              OrderModel order = OrderModel()
                ..address = 'Alexandria'
                ..createdAt = DateTime.now()
                ..status = 'pending'
                ..totalPrice = totalPrice.value
                ..userId = authProvider.user!.authID;

              await context.read<OrderProvider>().placeOrder(
                order,
                widget.orderItems,
              );
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: Text('Confirm', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Items: ${widget.orderItems.length}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  ValueListenableBuilder(
                    valueListenable: totalPrice,
                    builder: (context, value, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${value.toStringAsFixed(2)} EGP',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _handleCheckout(),
                icon: Icon(Icons.shopping_bag_outlined),
                label: Text('Checkout'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
