import 'package:flutter/material.dart';
import 'package:foodapp/l10n/app_localizations.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:foodapp/providers/order_provider.dart';
import 'package:foodapp/screens/widgets/order_details_sheet.dart';
import 'package:provider/provider.dart';

class AdminOrderTabView extends StatelessWidget {
  final List<OrderModel> orders;
  final List<OrderItemModel> orderItems;
  final VoidCallback onRefresh;

  const AdminOrderTabView({
    required this.orders,
    required this.orderItems,
    required this.onRefresh,
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

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) => _OrderCard(
          order: orders[index],
          orderItems: orderItems
              .where((item) => item.orderId == orders[index].orderId)
              .toList(),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final List<OrderItemModel> orderItems;

  const _OrderCard({required this.order, required this.orderItems});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () =>
            showOrderDetails(context, order: order, orderItems: orderItems),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _OrderHeader(orderId: order.orderId!, userId: order.userId),
              const SizedBox(height: 12),
              _OrderInfo(order: order, itemCount: orderItems.length),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              _OrderFooter(order: order, orderItems: orderItems),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderHeader extends StatelessWidget {
  final int orderId;
  final String userId;
  const _OrderHeader({required this.orderId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppLocalizations.of(context).t('order')} #$orderId',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.person, size: 14, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                AppLocalizations.of(context).t(
                  'user:Id',
                  data: {
                    'id':
                        userId.substring(
                          0,
                          userId.length > 20 ? 20 : userId.length,
                        ) +
                        (userId.length > 20 ? '...' : ''),
                  },
                ),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OrderInfo extends StatelessWidget {
  final OrderModel order;
  final int itemCount;
  _OrderInfo({required this.order, required this.itemCount});

  final List<String> statusVal = [
    'pending',
    'processing',
    'completed',
    'delivered',
  ];

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';
    try {
      final formatted = date.toString().split('.')[0];
      return formatted;
    } catch (e) {
      return 'N/A';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'delivered':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _InfoItem(
                label: AppLocalizations.of(context).t('orderDate'),
                value: _formatDate(order.createdAt),
                icon: Icons.calendar_today,
              ),
            ),
            const SizedBox(width: 16),
            _InfoItem(
              label: AppLocalizations.of(context).t('items'),
              value:
                  '$itemCount ${itemCount == 1 ? AppLocalizations.of(context).t('item') : AppLocalizations.of(context).t('items')}',
              icon: Icons.shopping_bag,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).t('deliveryAddressLabel'),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.address,
                    style: const TextStyle(fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _getStatusColor(order.status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _getStatusColor(order.status), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getStatusIcon(order.status),
                size: 16,
                color: _getStatusColor(order.status),
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).t(order.status).toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  color: _getStatusColor(order.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.pending;
      case 'processing':
        return Icons.restaurant;
      case 'completed':
        return Icons.check_circle;
      case 'delivered':
        return Icons.local_shipping;
      default:
        return Icons.help_outline;
    }
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _OrderFooter extends StatelessWidget {
  final OrderModel order;
  final List<OrderItemModel> orderItems;

  const _OrderFooter({required this.order, required this.orderItems});

  static const List<String> statusVal = [
    'pending',
    'processing',
    'completed',
    'delivered',
  ];

  String _getNextStatus(String currentStatus) {
    final currentIndex = statusVal.indexWhere(
      (s) => s.toLowerCase() == currentStatus.toLowerCase(),
    );
    if (currentIndex == -1 || currentIndex >= statusVal.length - 1) {
      return statusVal.last;
    }
    return statusVal[currentIndex + 1];
  }

  @override
  Widget build(BuildContext context) {
    final canUpdate = order.status.toLowerCase() != 'delivered';
    final nextStatus = _getNextStatus(order.status);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).t('orderTotal'),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${AppLocalizations.of(context).t('egp')} ${order.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        if (canUpdate)
          ElevatedButton.icon(
            onPressed: () async {
              await context.read<OrderProvider>().updateOrder(
                order.orderId!,
                nextStatus,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${AppLocalizations.of(context).t('orderStatusUpdatedTo')} ${AppLocalizations.of(context).t(nextStatus.toLowerCase())}',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: Text(
              '${AppLocalizations.of(context).t('markAs')}${AppLocalizations.of(context).t(nextStatus.toLowerCase())}',
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
