import 'package:flutter/material.dart';
import 'package:foodapp/l10n/app_localizations.dart';
import 'package:foodapp/models/item%20model/item_model.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:foodapp/providers/menu_provider.dart';
import 'package:foodapp/screens/widgets/item_details_sheet.dart';
import 'package:foodapp/screens/common/customer_details_screen.dart';
import 'package:provider/provider.dart';

void showOrderDetails(
  BuildContext context, {
  required OrderModel order,
  required List<OrderItemModel> orderItems,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) =>
        OrderDetailsSheet(order: order, orderItems: orderItems),
  );
}

class OrderDetailsSheet extends StatelessWidget {
  final OrderModel order;
  final List<OrderItemModel> orderItems;

  const OrderDetailsSheet({
    super.key,
    required this.order,
    required this.orderItems,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    try {
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context).t('order')} #${order.orderId}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const Divider(), // Content
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  _DetailSection(
                    title: AppLocalizations.of(context).t('orderInformation'),
                    children: [
                      _DetailRow(
                        label: AppLocalizations.of(context).t('orderId'),
                        value: '#${order.orderId}',
                      ),
                      Consumer<AuthProvider>(
                        builder: (context, authProv, _) {
                          if (authProv.isLoading) {
                            return _DetailRow(
                              label: AppLocalizations.of(
                                context,
                              ).t('customerName'),
                              value: AppLocalizations.of(
                                context,
                              ).t('loading...'),
                            );
                          }

                          final users = authProv.users;
                          return InkWell(
                            onTap: () {
                              final user = users
                                  .where((u) => u.authID == order.userId)
                                  .firstOrNull;

                              if (user != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CustomerDetailsScreen(user: user),
                                  ),
                                );
                              }
                            },
                            child: _DetailRow(
                              label: AppLocalizations.of(
                                context,
                              ).t('customerName'),
                              value:
                                  context
                                      .read<AuthProvider>()
                                      .users
                                      .where(
                                        (user) => user.authID == order.userId,
                                      )
                                      .firstOrNull
                                      ?.name ??
                                  'N/A',
                            ),
                          );
                        },
                      ),
                      _DetailRow(
                        label: AppLocalizations.of(context).t('date'),
                        value: _formatDate(order.createdAt),
                      ),
                      _DetailRow(
                        label: AppLocalizations.of(context).t('status'),
                        value: order.status.toUpperCase(),
                      ),
                      _DetailRow(
                        label: AppLocalizations.of(context).t('total'),
                        value: 'EGP${order.totalPrice.toStringAsFixed(2)}',
                        isHighlighted: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _DetailSection(
                    title: AppLocalizations.of(context).t('deliveryAddress'),
                    children: [
                      Text(order.address, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _DetailSection(
                    title:
                        '${AppLocalizations.of(context).t('orderItems')} (${orderItems.length})',
                    children: [
                      const SizedBox(height: 8),
                      ...orderItems.map(
                        (item) => Consumer<MenuProvider>(
                          builder: (context, menuProvider, child) {
                            final menuItem = menuProvider.items
                                .where((i) => i.itemId == item.itemId)
                                .firstOrNull;
                            final categoryName = menuItem != null
                                ? menuProvider.categories
                                      .where(
                                        (cat) =>
                                            cat.categoryId ==
                                            menuItem.categoryId,
                                      )
                                      .first
                                      .name
                                : AppLocalizations.of(context).t('error');
                            return _OrderItemRow(
                              item: item,
                              menuItem: menuItem!,
                              categoryName: categoryName,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _DetailSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlighted;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: isHighlighted ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final OrderItemModel item;
  final ItemModel menuItem;
  final String categoryName;

  const _OrderItemRow({
    required this.item,
    required this.menuItem,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showItemDetails(
        context,
        item: menuItem,
        categoryName: categoryName,
        needButton: false,
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menuItem.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${AppLocalizations.of(context).t('quantity')}: ${item.quantity} × EGP${item.price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Text(
              'EGP${(item.quantity * item.price).toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
