import 'package:clothshop/models/product.dart';
import 'package:clothshop/models/shop.dart';
import 'package:clothshop/utils/cloth_cart_tile.dart';
import 'package:clothshop/utils/custom_drawer.dart';
import 'package:clothshop/utils/mybutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void removeFromCart(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('Remove this item from your cart'),
        actions: [
          MaterialButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          MaterialButton(
            child: Text('Remove'),
            onPressed: () {
              Navigator.pop(context);
              context.read<Shop>().removeToUserProducts(product);
            },
          ),
        ],
      ),
    );
  }

  void payButtonPressed() {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(content: Text('You don\'t have money asshole!!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProducts = context.watch<Shop>().getUserProducts();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Cart Page'),
      ),
      drawer: CustomDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: userProducts.isEmpty
                ? Center(child: Text('Your cart is empty'))
                : ListView.builder(
                    itemCount: userProducts.length,
                    itemBuilder: (context, index) {
                      Product product = userProducts[index];

                      return ClothCartTile(
                        product: product,
                        onPressed: () => removeFromCart(product),
                      );
                    },
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(40),
            child: Mybutton(onTap: payButtonPressed, child: Text('Pay Now')),
          ),
        ],
      ),
    );
  }
}
