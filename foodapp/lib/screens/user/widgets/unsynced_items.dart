import 'package:flutter/material.dart';
import 'package:foodapp/models/item%20model/item_model.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:foodapp/providers/menu_provider.dart';
import 'package:foodapp/providers/order_provider.dart';
import 'package:foodapp/screens/user/widgets/quantity_control.dart';
import 'package:provider/provider.dart';

class UnsyncedItems extends StatefulWidget {
  final OrderProvider orderProvider;

  const UnsyncedItems({super.key, required this.orderProvider});

  @override
  State<UnsyncedItems> createState() => _UnsyncedItemsState();
}

class _UnsyncedItemsState extends State<UnsyncedItems> {
  late ValueNotifier<double> totalPrice = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.orderProvider.orderItemsSub,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (asyncSnapshot.hasError) {
          return Center(
            child: Text('Error Occured during fetching order items'),
          );
        }

        final unsyncedItems = asyncSnapshot.data
            ?.where((item) => item.synced == false)
            .toList();

        if (unsyncedItems!.isEmpty) {
          return Center(
            child: Text(
              'All order syncronoused. Do you want to order something?',
            ),
          );
        }

        double temp = 0;
        for (final item in unsyncedItems) {
          temp += item.price * item.quantity;
        }
        totalPrice.value = temp;

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: unsyncedItems.length,
                itemBuilder: (context, index) => _OrderItemCard(
                  orderItemModel: unsyncedItems[index],
                  onChangeQty: (qty) {
                    unsyncedItems[index].quantity = qty;
                    double temp = 0;
                    for (final item in unsyncedItems) {
                      temp += item.price * item.quantity;
                    }
                    totalPrice.value = temp;
                  },
                  onDeleteOrderItem: () => widget.orderProvider
                      .deleteOrderItemLocally(unsyncedItems[index].id),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsGeometry.all(16),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: totalPrice,
                      builder: (context, value, child) {
                        return Expanded(
                          child: Text('Total Price : $value EGP'),
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        OrderModel order = OrderModel()
                          ..address = 'Alexandria'
                          ..createdAt = DateTime.now()
                          ..status = 'pending'
                          ..totalPrice = totalPrice.value
                          ..userId = context.read<AuthProvider>().user!.authID;
                        await widget.orderProvider.placeOrder(
                          order,
                          unsyncedItems,
                        );
                      },
                      child: Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OrderItemCard extends StatefulWidget {
  final OrderItemModel orderItemModel;
  final Function(int) onChangeQty;
  final Function() onDeleteOrderItem;
  const _OrderItemCard({
    required this.orderItemModel,
    required this.onChangeQty,
    required this.onDeleteOrderItem,
  });

  @override
  State<_OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<_OrderItemCard> {
  late Future<ItemModel?> item;

  @override
  void initState() {
    getItem();
    super.initState();
  }

  void getItem() async {
    item = context.read<MenuProvider>().getItem(widget.orderItemModel.itemId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: item,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (asyncSnapshot.hasError) {
          return Center(child: Text('Error in Fetching item'));
        }

        final item = asyncSnapshot.data;

        return Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: BoxBorder.all(color: Colors.white),
          ),
          child: Row(
            children: [
              _CartItemImage(imageUrl: item!.imageUrl),
              const SizedBox(width: 12),
              _CartItemDetails(name: item.name, price: item.price),
              QuantityControl(
                quantity: widget.orderItemModel.quantity,
                onChangeQuantity: widget.onChangeQty,
              ),
              const SizedBox(width: 8),
              _DeleteButton(onPressed: widget.onDeleteOrderItem),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================================
// Cart Item Image
// ============================================================================
class _CartItemImage extends StatelessWidget {
  final String imageUrl;

  const _CartItemImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
    );
  }
}

// ============================================================================
// Cart Item Details
// ============================================================================
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '$price EGP',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Delete Button
// ============================================================================
class _DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _DeleteButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete_outline, color: Colors.red),
      onPressed: onPressed,
      splashRadius: 24,
    );
  }
}
