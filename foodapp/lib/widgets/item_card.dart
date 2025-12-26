import 'package:flutter/material.dart';
import 'package:foodapp/models/item%20model/item_model.dart';

class ItemCard extends StatefulWidget {
  final ItemModel item;
  final String catName;
  final Function(bool) onQuantityChanged;

  const ItemCard({
    super.key,
    required this.item,
    required this.catName,
    required this.onQuantityChanged,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(12),
              child: Image.network(
                widget.item.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(widget.item.name),
            subtitle: Text(widget.catName),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: widget.item.available ? Colors.green : Colors.grey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                widget.item.available ? 'Available' : 'Out of Stock',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Divider(color: Colors.black54),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Price: \$${widget.item.price}'),
                selected
                    ? IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            selected = true;
                            widget.onQuantityChanged(selected);
                          });
                        },
                        icon: Icon(Icons.shopping_cart),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
