import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoeshop/models/cart.dart';
import 'package:shoeshop/models/shoe_model.dart';
import 'package:shoeshop/utils/user_shoe_tile.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, value, child) => Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Text(
              'My Cart',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: value.getUserList().length,
                itemBuilder: (context, index) {
                  ShoeModel shoe = value.getUserList()[index];

                  return UserShoeTile(shoe: shoe);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
