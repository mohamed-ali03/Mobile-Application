import 'package:flutter/material.dart';
import 'package:restaurant/core/constants.dart';
import 'package:restaurant/feature/home/functions.dart';
import 'package:restaurant/feature/home/pages/admin/add_update_item_page.dart';
import 'package:restaurant/feature/home/widgets/custom_app_bar.dart';
import 'package:restaurant/feature/home/widgets/custom_ingredient_tile.dart';
import 'package:restaurant/feature/home/widgets/rate_box.dart';
import 'package:restaurant/feature/models/product_item.dart';

class ItemPage extends StatelessWidget {
  final ProductItem item;
  const ItemPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),

                CustomAppBar(
                  title: 'Food Details',
                  textButton: 'EDIT',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddOrUpdateItemPage(item: item),
                    ),
                  ),
                ),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: showItemPicture(),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.itemName,
                      style: TextStyle(
                        fontSize: fontLarge,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '\$${item.price}',
                      style: TextStyle(
                        fontSize: fontLarge,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: RateBox(
                    rate: item.rating ?? 0,
                    reviews: item.numOfReviews ?? 0,
                  ),
                ),

                _customDivider(),

                _showIngreidents(),

                _customDivider(),

                _descriptionfield(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _customDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Divider(height: 0.5, color: Colors.grey.shade400),
    );
  }

  Widget _showIngreidents() {
    final ingredients = item.ingredients?.keys.toList() ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'INGREIDENTS',
          style: TextStyle(fontSize: fontLarge, color: Colors.black),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: ingredients.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return CustomIngredientTile();
            },
          ),
        ),
      ],
    );
  }

  Widget _descriptionfield() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(fontSize: fontLarge, color: Colors.black),
        ),
        Text(item.description ?? 'No description available'),
      ],
    );
  }
}
