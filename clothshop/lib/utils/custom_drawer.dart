import 'package:clothshop/utils/custom_list_tile.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(child: Icon(Icons.shopping_bag, size: 100)),
                CustomListTile(
                  icon: Icons.home,
                  text: 'Shop',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/shopPage');
                  },
                ),
                CustomListTile(
                  icon: Icons.shopping_cart,
                  text: 'Cart',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/cartPage');
                  },
                ),
              ],
            ),

            CustomListTile(
              icon: Icons.logout,
              text: 'Exit',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/introPage');
              },
            ),
          ],
        ),
      ),
    );
  }
}
