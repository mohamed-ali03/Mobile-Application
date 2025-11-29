import 'package:clothshop/models/product.dart';
import 'package:clothshop/models/shop.dart';
import 'package:clothshop/utils/custom_drawer.dart';
import 'package:clothshop/utils/custom_product_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  void addToCart(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('Add this item to your cart'),
        actions: [
          MaterialButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          MaterialButton(
            child: Text('Add'),
            onPressed: () {
              Navigator.pop(context);
              context.read<Shop>().addToUserProducts(product);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<Shop>().getShopProducts();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Shope Page'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/cartPage'),
            icon: Icon(Icons.shopping_bag),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            child: Text(
              'Pick from a selected list of premium products',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 20,
              ),
            ),
          ),

          SizedBox(
            height: 1000,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                Product product = products[index];
                return CustomProductTile(
                  product: product,
                  onTap: () => addToCart(product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
