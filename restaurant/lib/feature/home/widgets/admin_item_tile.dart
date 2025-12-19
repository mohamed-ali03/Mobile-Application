import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/core/widgets/show_image.dart';
import 'package:restaurant/feature/home/pages/admin/supported%20pages/add_update_item_page.dart';
import 'package:restaurant/feature/home/provider/fire_store_provider.dart';
import 'package:restaurant/feature/home/widgets/category_name_box.dart';
import 'package:restaurant/feature/home/widgets/rate_box.dart';
import 'package:restaurant/feature/models/product_item.dart';

class AdminItemTile extends StatelessWidget {
  final ProductItem item;
  final Function()? onTap;
  const AdminItemTile({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // make the whole field pressable
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10),
        height: 150,
        color: Colors.transparent,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Center(child: ShowImage(imageUrl: item.imageUrl)),
            ),
            SizedBox(width: 10),
            Expanded(flex: 2, child: _showItemInfo()),
            Expanded(flex: 1, child: _thirdColumn(context)),
          ],
        ),
      ),
    );
  }

  Widget _showItemInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.itemName,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        CategoryNameBox(catName: item.categoryName),
        RateBox(rate: item.rating!, reviews: item.numOfReviews!),
      ],
    );
  }

  Widget _thirdColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        PopupMenuButton(
          onSelected: (value) {
            if (value == 'edit') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddOrUpdateItemPage(item: item),
                ),
              );
            } else if (value == 'delete') {
              context.read<FireStoreProvider>().deleteItem(
                item.categoryId,
                item.itemId,
                item.imageUrl,
              );
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(value: 'edit', child: Text("Modify")),
            PopupMenuItem(value: 'delete', child: Text("Delete")),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Text(
            '\$${item.price}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
