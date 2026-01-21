import 'package:flutter/material.dart';
import 'package:foodapp/l10n/app_localizations.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:foodapp/providers/order_provider.dart';
import 'package:foodapp/screens/user/widgets/user_cart_order_item.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class UnsyncedItems extends StatefulWidget {
  List<OrderItemModel> orderItems;

  UnsyncedItems({super.key, required this.orderItems});

  @override
  State<UnsyncedItems> createState() => _UnsyncedItemsState();
}

class _UnsyncedItemsState extends State<UnsyncedItems> {
  final ValueNotifier<double> totalPrice = ValueNotifier<double>(0);
  final addressController = TextEditingController();
  late OrderProvider orderProvider;
  bool isChanged = false;

  @override
  void initState() {
    super.initState();
    orderProvider = context.read<OrderProvider>();
    _calculateTotal();
  }

  @override
  void dispose() {
    if (isChanged) {
      orderProvider.updateOrderItemsLocally(widget.orderItems);
    }
    totalPrice.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    double temp = 0;
    for (final item in widget.orderItems) {
      temp += item.price * item.quantity;
    }
    totalPrice.value = temp;
  }

  Future<void> _confirmDeleteItem(int index) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(AppLocalizations.of(context).t('deleteItem')),
        content: Text(
          AppLocalizations.of(context).t('areYouSureYouWantToDeleteThisItem'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text(AppLocalizations.of(context).t('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: Text(
              AppLocalizations.of(context).t('delete'),
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (shouldDelete == true) {
      orderProvider.deleteOrderItemLocally(id: widget.orderItems[index].id);
      isChanged = true;
      _calculateTotal();
      setState(() {});
    }
  }

  void _onDeleteItem(int index) => _confirmDeleteItem(index);

  Future<void> _handleCheckout() async {
    final authProvider = context.read<AuthProvider>();
    final orderprovider = context.read<OrderProvider>();

    if (authProvider.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).t('pleaseLoginToContinue'),
          ),
        ),
      );
      return;
    }

    if (widget.orderItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).t('noItemsToCheckout')),
        ),
      );
      return;
    }

    // Show dialog that returns the entered address (or null if cancelled).

    final address = await showDialog<String?>(
      context: context,
      builder: (c) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).t('checkout')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context).t('confirmCheckout')),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).t('deliveryAddress'),
                  hintText: AppLocalizations.of(
                    context,
                  ).t('enterDeliveryAddress'),
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c, null),
              child: Text(AppLocalizations.of(context).t('cancel')),
            ),
            TextButton(
              onPressed: () {
                final value = addressController.text.trim();
                addressController.clear();
                Navigator.pop(c, value.isEmpty ? null : value);
              },
              child: Text(
                AppLocalizations.of(context).t('confirm'),
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );

    // If user cancelled or provided no address, stop
    if (address == null || address.isEmpty) {
      if (mounted && (address == null)) {
        // cancelled - do nothing
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).t('pleaseProvideADeliveryAddress'),
            ),
          ),
        );
      }
      return;
    }

    final order = OrderModel()
      ..address = address
      ..status = 'pending'
      ..totalPrice = totalPrice.value
      ..userId = authProvider.user!.authID;

    await orderprovider.placeOrder(order, widget.orderItems);
  }

  @override
  Widget build(BuildContext context) {
    _calculateTotal();

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: widget.orderItems.length,
            separatorBuilder: (_, _) => const SizedBox(height: 6),
            itemBuilder: (context, index) {
              final orderItem = widget.orderItems[index];
              return OrderItemCard(
                orderItem: orderItem,
                onChangeQty: (qty) {
                  orderItem.quantity = qty;
                  isChanged = true;
                  _calculateTotal();
                  setState(() {});
                },
                onDeleteOrderItem: () => _onDeleteItem(index),
              );
            },
          ),
        ),
        _buildCheckoutSection(),
      ],
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).t('orderSummary'),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ValueListenableBuilder<double>(
                  valueListenable: totalPrice,
                  builder: (context, value, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppLocalizations.of(context).t('countOfItems')} ${widget.orderItems.length.toString()} ',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context).t('total'),
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context).t(
                            'currency',
                            data: {'amount': value.toStringAsFixed(2)},
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: widget.orderItems.isEmpty ? null : _handleCheckout,
                icon: const Icon(Icons.shopping_bag_outlined),
                label: Text(AppLocalizations.of(context).t('checkout')),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
