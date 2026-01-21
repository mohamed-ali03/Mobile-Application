import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/providers/menu_provider.dart';
import 'package:foodapp/screens/user/widgets/user_cart_quantity_control.dart';
import 'package:provider/provider.dart';

class OrderItemCard extends StatelessWidget {
  final OrderItemModel orderItem;
  final Function(int) onChangeQty;
  final Function() onDeleteOrderItem;

  const OrderItemCard({
    super.key,
    required this.orderItem,
    required this.onChangeQty,
    required this.onDeleteOrderItem,
  });

  @override
  Widget build(BuildContext context) {
    final item = context
        .read<MenuProvider>()
        .items
        .where((item) => item.itemId == orderItem.itemId)
        .first;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [BoxShadow(color: Colors.grey[100]!, blurRadius: 4)],
      ),
      child: Row(
        children: [
          _CartItemImage(imageUrl: item.imageUrl),
          const SizedBox(width: 12),
          _CartItemDetails(name: item.name, price: item.price),
          QuantityControl(
            quantity: orderItem.quantity,
            onChangeQuantity: onChangeQty,
          ),
          const SizedBox(width: 8),
          _DeleteButton(onPressed: onDeleteOrderItem),
        ],
      ),
    );
  }
}

class _CartItemImage extends StatelessWidget {
  final String imageUrl;

  const _CartItemImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorWidget: (context, error, stackTrace) {
          return Container(
            width: 60,
            height: 60,
            color: Colors.grey[300],
            child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
          );
        },
      ),
    );
  }
}

class _CartItemDetails extends StatelessWidget {
  final String name;
  final double price;

  const _CartItemDetails({required this.name, required this.price});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            '${price.toStringAsFixed(2)} EGP',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _DeleteButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete_outline, color: Colors.red),
      onPressed: onPressed,
      tooltip: 'Remove item',
      splashRadius: 24,
    );
  }
}
