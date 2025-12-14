import 'package:flutter/material.dart';
import 'package:restaurant/core/constants.dart';
import 'package:restaurant/core/widgets/custom_divider.dart';
import 'package:restaurant/core/widgets/show_image.dart';
import 'package:restaurant/feature/home/pages/admin/supported%20pages/add_update_item_page.dart';
import 'package:restaurant/feature/home/widgets/custom_app_bar.dart';
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
                  // if it pressed you will go to another page to edit this item
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddOrUpdateItemPage(item: item),
                    ),
                  ),
                ),

                // show the image of the item
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: ShowImage(imageUrl: item.imageUrl),
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
                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RateBox(
                      rate: item.rating ?? 0,
                      reviews: item.numOfReviews ?? 0,
                    ),
                    item.isAvailable
                        ? Text(
                            'Available',
                            style: TextStyle(color: Colors.orange),
                          )
                        : Text(
                            'Not Available',
                            style: TextStyle(color: Colors.grey),
                          ),
                  ],
                ),

                CustomDivider(),

                _showData('INGREIDENT', item.ingredients),
                CustomDivider(),

                _showData('DESCRIPTION', item.description),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _showData(String title, String content) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: fontLarge, color: Colors.black),
          ),
          Text(content),
        ],
      ),
    );
  }
}
