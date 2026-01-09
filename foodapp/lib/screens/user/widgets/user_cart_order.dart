import 'package:flutter/material.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:foodapp/providers/order_provider.dart';
import 'package:foodapp/screens/widgets/order_details_sheet.dart';
import 'package:provider/provider.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final List<OrderItemModel> orderItems;

  const OrderCard({super.key, required this.order, required this.orderItems});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          showOrderDetails(context, order: order, orderItems: orderItems),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _OrderHeader(
              id: order.id,
              orderId: order.orderId,
              status: order.status,
              isUnsynced: !order.synced,
            ),
            const SizedBox(height: 12),
            _OrderInfo(
              address: order.address,
              date: order.createdAt,
              status: order.status,
              itemCount: orderItems.length,
              orderId: order.orderId,
              isUnsynced: !order.synced,
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 8),
            _OrderFooter(
              totalPrice: order.totalPrice,
              isUnsynced: !order.synced,
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderHeader extends StatelessWidget {
  final int id;
  final int? orderId;
  final String status;
  final bool isUnsynced;
  const _OrderHeader({
    required this.id,
    required this.orderId,
    required this.status,
    required this.isUnsynced,
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
                'Order #$id',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'ID: ${orderId ?? 'unsynced'}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
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
                      child: const Text(
                        'UNSYNCED',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        _MyPupupMenuButton(
          status: status,
          orderId: orderId,
          isUnsynced: isUnsynced,
        ),
      ],
    );
  }
}

class _MyPupupMenuButton extends StatelessWidget {
  final String status;
  final int? orderId;
  final bool isUnsynced;
  const _MyPupupMenuButton({
    required this.status,
    required this.orderId,
    required this.isUnsynced,
  });

  Future<void> _syncOrders(BuildContext context) async {
    final provider = context.read<OrderProvider>();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Syncing orders...'),
        duration: Duration(seconds: 2),
      ),
    );
    try {
      await provider.syncOrders();
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Sync completed')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Sync failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_horiz),
      onSelected: (value) {
        // handled in item entries' onTap
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Row(
            children: const [
              Icon(Icons.edit, size: 18),
              SizedBox(width: 8),
              Text('Edit Order'),
            ],
          ),
          onTap: () {
            if (status.toLowerCase() == 'pending') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.blue,
                  content: Text('Edit order functionality coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.orange,
                  content: Text(
                    'Orders cannot be edited once processing begins',
                  ),
                  duration: Duration(seconds: 3),
                ),
              );
            }
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              const Icon(Icons.delete, size: 18, color: Colors.red),
              const SizedBox(width: 8),
              Text('Delete Order', style: TextStyle(color: Colors.red)),
            ],
          ),
          onTap: () {
            if (status.toLowerCase() == 'pending') {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Order'),
                  content: const Text(
                    'Are you sure you want to delete this order?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<OrderProvider>().deleteOrder(orderId ?? 0);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.orange,
                  content: Text(
                    'Orders cannot be deleted once processing begins',
                  ),
                  duration: Duration(seconds: 3),
                ),
              );
            }
          },
        ),
        if (isUnsynced)
          PopupMenuItem(
            child: Row(
              children: const [
                Icon(Icons.sync, size: 18, color: Colors.green),
                SizedBox(width: 8),
                Text('Sync Orders'),
              ],
            ),
            onTap: () => _syncOrders(context),
          ),
      ],
    );
  }
}

class _OrderInfo extends StatelessWidget {
  final DateTime? date;
  final String address;
  final String status;
  final int itemCount;
  final int? orderId;
  final bool isUnsynced;

  const _OrderInfo({
    required this.address,
    required this.date,
    required this.status,
    required this.itemCount,
    required this.orderId,
    required this.isUnsynced,
  });

  String _formatDate(dynamic date) {
    if (date == null) return 'unsynced';
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Date',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(date),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Items',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Delivery Address',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          address.isNotEmpty
              ? address
              : (isUnsynced ? 'Unsynced (local only)' : 'N/A'),
          style: const TextStyle(fontSize: 13),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _getStatusColor(status),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            status.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderFooter extends StatelessWidget {
  final double? totalPrice;
  final bool isUnsynced;

  const _OrderFooter({required this.totalPrice, required this.isUnsynced});

  Future<void> _syncOrders(BuildContext context) async {
    final provider = context.read<OrderProvider>();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Syncing orders...'),
        duration: Duration(seconds: 2),
      ),
    );
    try {
      await provider.syncOrders();
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Sync completed')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Sync failed: $e')));
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
              'Order Total',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'EGP${totalPrice?.toStringAsFixed(2) ?? "0.00"}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        Row(
          children: [
            if (isUnsynced)
              TextButton.icon(
                onPressed: () => _syncOrders(context),
                icon: const Icon(Icons.sync, color: Colors.green),
                label: const Text(
                  'Sync',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.check_circle, color: Colors.green, size: 28),
          ],
        ),
      ],
    );
  }
}
