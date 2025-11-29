import 'package:clothshop/models/product.dart';
import 'package:flutter/material.dart';

class ClothCartTile extends StatefulWidget {
  final Product product;
  final void Function()? onPressed;
  const ClothCartTile({
    super.key,
    required this.product,
    required this.onPressed,
  });

  @override
  State<ClothCartTile> createState() => _ClothCartTileState();
}

class _ClothCartTileState extends State<ClothCartTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      padding: EdgeInsets.all(10),
      child: ListTile(
        leading: Image.asset(widget.product.imagePath),
        title: Text(widget.product.name),
        subtitle: Text('\$${widget.product.price}'),

        trailing: IconButton(
          onPressed: widget.onPressed,
          icon: Icon(Icons.delete),
        ),
      ),
    );
  }
}
