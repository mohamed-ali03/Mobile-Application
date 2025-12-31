import 'package:flutter/material.dart';
import 'package:foodapp/models/category%20model/category_model.dart';
import 'package:foodapp/models/item%20model/item_model.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/providers/order_provider.dart';
import 'package:foodapp/screens/user/widgets/item_card.dart';
import 'package:provider/provider.dart';

class MenuItemsByCategory extends StatelessWidget {
  final ValueNotifier<int> selCategory;
  final ValueNotifier<String> searchTxt;
  final List<ItemModel> allItems;
  final List<CategoryModel> categories;
  const MenuItemsByCategory({
    super.key,
    required this.selCategory,
    required this.searchTxt,
    required this.allItems,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selCategory,
      builder: (context, catIndex, _) {
        return ValueListenableBuilder(
          valueListenable: searchTxt,
          builder: (context, query, _) {
            var items = allItems;

            if (catIndex != 0) {
              items = allItems
                  .where(
                    (item) =>
                        item.categoryId == categories[catIndex - 1].categoryId,
                  )
                  .toList();
            }

            if (query.isNotEmpty) {
              items = items
                  .where(
                    (item) =>
                        item.name.toLowerCase().contains(query.toLowerCase()),
                  )
                  .toList();
            }

            return ListView.builder(
              itemCount: items.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = items[index];
                return ItemCard(
                  item: item,
                  catName: categories
                      .firstWhere((cat) => cat.categoryId == item.categoryId)
                      .name,
                  onSelectItem: (x) {
                    if (x) {
                      final orderItem = OrderItemModel()
                        ..itemId = item.itemId
                        ..price = item.price
                        ..quantity = 1;
                      context.read<OrderProvider>().upsertOrderItemLocally(
                        orderItem,
                      );
                    } else {
                      context.read<OrderProvider>().deleteOrderItemLocally(
                        itemId: item.itemId,
                      );
                    }
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
