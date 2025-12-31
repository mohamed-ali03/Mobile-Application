import 'package:flutter/material.dart';
import 'package:foodapp/providers/menu_provider.dart';
import 'package:foodapp/screens/user/widgets/item_card.dart';
import 'package:provider/provider.dart';

class AdminMenuScreen extends StatelessWidget {
  const AdminMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menu Management')),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
        child: Consumer<MenuProvider>(
          builder: (context, value, child) {
            if (value.items.isEmpty || value.categories.isEmpty) {
              return Center(child: Text('there are no items'));
            }

            return ListView.builder(
              itemCount: value.items.length,
              itemBuilder: (context, index) {
                return ItemCard(
                  item: value.items[index],
                  catName: value.categories
                      .where(
                        (cat) =>
                            cat.categoryId == value.items[index].categoryId,
                      )
                      .first
                      .name,
                  onSelectItem: (_) {},
                );
              },
            );
          },
        ),
      ),
    );
  }
}
