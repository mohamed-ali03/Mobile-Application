// ============================================================================
// Delete Confirmation Dialog
// ============================================================================
import 'package:flutter/material.dart';
import 'package:foodapp/models/item%20model/item_model.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final ItemModel item;
  final OrderItemModel orderItem;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    super.key,
    required this.item,
    required this.orderItem,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        'Remove Item',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DeleteWarningBox(itemName: item.name),
          const SizedBox(height: 16),
          _DeleteItemSummary(item: item, orderItem: orderItem),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        FilledButton(
          onPressed: onConfirm,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          ),
          child: const Text('Remove'),
        ),
      ],
    );
  }
}

// ============================================================================
// Delete Warning Box
// ============================================================================
class _DeleteWarningBox extends StatelessWidget {
  final String itemName;

  const _DeleteWarningBox({required this.itemName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red[600], size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Are you sure you want to remove $itemName from your cart?',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Delete Item Summary
// ============================================================================
class _DeleteItemSummary extends StatelessWidget {
  final ItemModel item;
  final OrderItemModel orderItem;

  const _DeleteItemSummary({required this.item, required this.orderItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${orderItem.quantity}x ${item.name}',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          Text(
            '${orderItem.quantity * item.price} EGP',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
