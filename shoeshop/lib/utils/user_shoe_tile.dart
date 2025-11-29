import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoeshop/models/cart.dart';
import 'package:shoeshop/models/shoe_model.dart';

class UserShoeTile extends StatefulWidget {
  final ShoeModel shoe;
  const UserShoeTile({super.key, required this.shoe});

  @override
  State<UserShoeTile> createState() => _UserShoeTileState();
}

class _UserShoeTileState extends State<UserShoeTile> {
  void removeItemFromCart() {
    Provider.of<Cart>(context, listen: false).removeItemFromCart(widget.shoe);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: ListTile(
        leading: Image.asset(widget.shoe.shoeImage),
        title: Text(widget.shoe.shoeName),
        subtitle: Text(widget.shoe.shoePrice),

        trailing: IconButton(
          onPressed: removeItemFromCart,
          icon: Icon(Icons.delete),
        ),
      ),
    );
  }
}
