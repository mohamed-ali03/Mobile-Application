// ============================================================================
// Order Card
// ============================================================================
import 'package:flutter/material.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:isar/isar.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final Function(String) onGetStatusColor;
  final Function(dynamic) onFormatDate;

  const OrderCard({
    super.key,
    required this.order,
    required this.onGetStatusColor,
    required this.onFormatDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // TODO: order detail navigation here if needed
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _OrderHeader(
                orderId: order.id,
                status: order.status,
                onGetStatusColor: onGetStatusColor,
              ),
              const SizedBox(height: 12),
              _OrderInfo(
                date: onFormatDate(order.createdAt),
                address: order.address,
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.grey[300]),
              const SizedBox(height: 8),
              _OrderFooter(totalPrice: order.totalPrice),
              if (order.synced == false) ...[
                const SizedBox(height: 8),
                _SyncingIndicator(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Order Header
// ============================================================================
class _OrderHeader extends StatelessWidget {
  final Id orderId;
  final String status;
  final Function(String) onGetStatusColor;

  const _OrderHeader({
    required this.orderId,
    required this.status,
    required this.onGetStatusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Order #$orderId',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: onGetStatusColor(status) as Color,
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

// ============================================================================
// Order Info
// ============================================================================
class _OrderInfo extends StatelessWidget {
  final String date;
  final String address;

  const _OrderInfo({required this.date, required this.address});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📅 $date',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Text(
          '📍 $address',
          style: const TextStyle(fontSize: 12),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// ============================================================================
// Order Footer
// ============================================================================
class _OrderFooter extends StatelessWidget {
  final double? totalPrice;

  const _OrderFooter({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text(
          '\$${totalPrice?.toStringAsFixed(2) ?? "0.00"}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// Syncing Indicator
// ============================================================================
class _SyncingIndicator extends StatelessWidget {
  const _SyncingIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off, size: 14, color: Colors.orange),
          SizedBox(width: 4),
          Text(
            'Syncing...',
            style: TextStyle(fontSize: 11, color: Colors.orange),
          ),
        ],
      ),
    );
  }
}
