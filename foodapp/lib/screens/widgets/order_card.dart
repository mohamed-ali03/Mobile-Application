import 'package:flutter/material.dart';
import 'package:foodapp/l10n/app_localizations.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:foodapp/providers/order_provider.dart';
import 'package:foodapp/screens/widgets/order_details_sheet.dart';
import 'package:provider/provider.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final List<OrderItemModel> orderItems;

  const OrderCard({super.key, required this.order, required this.orderItems});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().user;
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
              if (user?.role == 'user')
                _UserOrderHeader(
                  id: order.id,
                  orderId: order.orderId,
                  status: order.status,
                  isUnsynced: !order.synced,
                  orderItems: orderItems,
                )
              else
                _AdminOrderHeader(
                  orderId: order.orderId!,
                  status: order.status,
                  userId: order.userId,
                ),
              const SizedBox(height: 12),
              _OrderInfo(order: order, itemCount: orderItems.length),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              if (user?.role == 'user')
                _UserOrderFooter(
                  totalPrice: order.totalPrice,
                  isUnsynced: !order.synced,
                  id: order.id,
                  msg: order.message ?? '',
                )
              else
                _AdminOrderFooter(
                  order: order,
                  orderItems: orderItems,
                  msg: order.message ?? '',
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserOrderHeader extends StatelessWidget {
  final int id;
  final int? orderId;
  final String status;
  final bool isUnsynced;
  final List<OrderItemModel> orderItems;
  const _UserOrderHeader({
    required this.id,
    required this.orderId,
    required this.status,
    required this.isUnsynced,
    required this.orderItems,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).t(
                  'order',
                  data: {
                    'orderId':
                        orderId?.toString() ??
                        AppLocalizations.of(context).t('unsynced'),
                  },
                ),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              if (isUnsynced) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    AppLocalizations.of(context).t('unsyncedLabel'),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (status.toLowerCase() == 'pending')
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context).t('deleteOrder')),
                  content: Text(
                    AppLocalizations.of(context).t('deleteOrderConfirm'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppLocalizations.of(context).t('cancel')),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<OrderProvider>().deleteOrder(
                          orderId: orderId,
                          id: id,
                        );
                        Navigator.pop(context);
                      },
                      child: Text(
                        AppLocalizations.of(context).t('delete'),
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.close),
          ),
      ],
    );
  }
}

class _AdminOrderHeader extends StatelessWidget {
  final int orderId;
  final String status;
  final String userId;
  final TextEditingController _messageController = TextEditingController();
  _AdminOrderHeader({
    required this.orderId,
    required this.userId,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(
                context,
              ).t('order', data: {'orderId': orderId.toString()}),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (status.toLowerCase() == 'pending')
              IconButton(
                onPressed: () async {
                  // show dialog
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(AppLocalizations.of(context).t('confirm')),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).t(
                              'areYouSureYouWantToCancelOrder',
                              data: {'order': orderId.toString()},
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(AppLocalizations.of(context).t('leaveAMessage')),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: AppLocalizations.of(
                                context,
                              ).t('enterAMessage'),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(AppLocalizations.of(context).t('cancel')),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(
                            AppLocalizations.of(context).t('confirm'),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirmed != true) return;
                  if (context.mounted) {
                    await context.read<OrderProvider>().updateOrder(
                      orderId,
                      'canceled',
                      msg: _messageController.text,
                    );
                  }
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context).t(
                            'orderStatusUpdatedTo',
                            data: {
                              'status': AppLocalizations.of(
                                context,
                              ).t('canceled'),
                            },
                          ),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                icon: Icon(Icons.remove),
              ),
          ],
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
    'canceled',
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
      case 'canceled':
        return Colors.red;
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
      case 'canceled':
        return Icons.cancel;
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

class _UserOrderFooter extends StatelessWidget {
  final double? totalPrice;
  final bool isUnsynced;
  final String msg;
  final int id; // local order id

  const _UserOrderFooter({
    required this.totalPrice,
    required this.isUnsynced,
    required this.id,
    this.msg = "",
  });

  Future<void> _syncOrders(BuildContext context) async {
    final provider = context.read<OrderProvider>();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).t('syncingOrders')),
        duration: Duration(seconds: 2),
      ),
    );
    try {
      await provider.syncOrder(id);
      if (context.mounted) {
        final error = provider.error;
        if (error != null && error.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 5),
              content: Text(
                AppLocalizations.of(
                  context,
                ).t('syncedFailed', data: {'error': error}),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).t('syncCompleted')),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 5),
            content: Text(
              AppLocalizations.of(
                context,
              ).t('syncedFailed', data: {'error': e.toString()}),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              AppLocalizations.of(context).t(
                'currency',
                data: {'amount': totalPrice?.toStringAsFixed(2) ?? "0.00"},
              ),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        if (isUnsynced)
          TextButton.icon(
            onPressed: () => _syncOrders(context),
            icon: const Icon(Icons.sync, color: Colors.green),
            label: Text(
              AppLocalizations.of(context).t('sync'),
              style: const TextStyle(color: Colors.green),
            ),
          ),
        if (msg.isNotEmpty)
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context).t('message')),
                  content: Text(msg),
                ),
              );
            },
            icon: Icon(Icons.message),
          ),
      ],
    );
  }
}

class _AdminOrderFooter extends StatelessWidget {
  final OrderModel order;
  final List<OrderItemModel> orderItems;
  final String msg;

  final TextEditingController _messageController = TextEditingController();

  _AdminOrderFooter({
    required this.order,
    required this.orderItems,
    this.msg = '',
  });

  static const List<String> statusVal = [
    'pending',
    'processing',
    'completed',
    'delivered',
    'canceled',
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
    final canUpdate =
        order.status.toLowerCase() != 'delivered' &&
        order.status.toLowerCase() != 'canceled';
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
              AppLocalizations.of(context).t(
                'currency',
                data: {'amount': order.totalPrice.toStringAsFixed(2)},
              ),
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
              if (context.mounted) {
                await context.read<OrderProvider>().updateOrder(
                  order.orderId!,
                  nextStatus,
                );
              }
              if (!context.mounted) return;
              if (nextStatus.toLowerCase() == 'delivered') {
                await context.read<AuthProvider>().updateProfile(
                  order.userId,
                  buyingPoints: true,
                );
              }
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context).t(
                        'orderStatusUpdatedTo',
                        data: {
                          'status': AppLocalizations.of(
                            context,
                          ).t(nextStatus.toLowerCase()),
                        },
                      ),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: Text(
              AppLocalizations.of(context).t(
                'markAs',
                data: {
                  'status': AppLocalizations.of(
                    context,
                  ).t(nextStatus.toLowerCase()),
                },
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        if (msg.isNotEmpty)
          IconButton(
            onPressed: () async {
              _messageController.text = msg;
              // show dialog
              final confirmed = await showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context).t('confirm')),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context).t('editMessage')),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: AppLocalizations.of(
                            context,
                          ).t('enterAMessage'),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'cancel'),
                      child: Text(AppLocalizations.of(context).t('cancel')),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'confirm'),
                      child: Text(AppLocalizations.of(context).t('confirm')),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'retrieve'),
                      child: Text(AppLocalizations.of(context).t('retrieve')),
                    ),
                  ],
                ),
              );
              if (context.mounted) {
                if (confirmed == 'retrieve') {
                  await context.read<OrderProvider>().updateOrder(
                    order.orderId!,
                    'pending',
                    msg: '',
                  );
                } else if (confirmed == 'confirm') {
                  await context.read<OrderProvider>().updateOrder(
                    order.orderId!,
                    'canceled',
                    msg: _messageController.text,
                  );
                } else {
                  return;
                }
              }
            },
            icon: Icon(Icons.message),
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
