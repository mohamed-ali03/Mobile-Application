import 'package:flutter/material.dart';
import 'package:foodapp/models/category%20model/category_model.dart';
import 'package:foodapp/models/item%20model/item_model.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:foodapp/providers/menu_provider.dart';
import 'package:foodapp/providers/order_provider.dart';
import 'package:foodapp/widgets/category_tap.dart';
import 'package:foodapp/widgets/item_card.dart';
import 'package:foodapp/widgets/my_drawer.dart';
import 'package:foodapp/widgets/search_box.dart';
import 'package:provider/provider.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final searchController = TextEditingController();
  ValueNotifier<int> selectedCat = ValueNotifier(0);
  ValueNotifier<String> searchText = ValueNotifier('');
  List<CategoryModel> categories = [];
  List<ItemModel> allItems = [];

  late AuthProvider authProvider;
  late MenuProvider menuProvider;
  late OrderProvider orderProvider;

  @override
  void initState() {
    authProvider = context.read<AuthProvider>();
    menuProvider = context.read<MenuProvider>();
    orderProvider = context.read<OrderProvider>();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchText.dispose();
    super.dispose();
  }

  void _natvigateToCart() {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/userCartScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _natvigateToCart,
            icon: Icon(Icons.shopping_cart),
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            _welcomeBox(),

            SizedBox(height: 20),

            // 🔍 Search Field
            SearchBox(
              searchController: searchController,
              searchText: searchText,
            ),

            SizedBox(height: 25),

            // 🍔 Categories Header
            Text(
              'All Categories',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildCategoriesRow(),
            SizedBox(height: 30),
            Expanded(child: _buildItemsByCategory()),
          ],
        ),
      ),
    );
  }

  Widget _welcomeBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome 👋', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 4),
        Text(
          '${authProvider.user?.name}',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Ready to order something delicious?',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildCategoriesRow() {
    return SizedBox(
      height: 60,
      child: StreamBuilder<List<CategoryModel>>(
        stream: menuProvider.categoriesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load categories'));
          }

          categories = [
            CategoryModel()
              ..categoryId = 0
              ..name = 'All'
              ..imageUrl = '',
            ...?snapshot.data,
          ];

          if (categories.isEmpty) {
            return const Center(child: Text('No categories'));
          }

          return ValueListenableBuilder(
            valueListenable: selectedCat,
            builder: (context, value, child) {
              return GridView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.4,
                ),
                itemBuilder: (context, index) {
                  return CategoryTap(
                    cat: categories[index],
                    selected: value == index,
                    onTap: () {
                      selectedCat.value = index;
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildItemsByCategory() {
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: menuProvider.itemsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load Items'));
          }

          allItems = snapshot.data ?? [];

          if (allItems.isEmpty) {
            return const Center(child: Text('No categories'));
          }

          return ValueListenableBuilder(
            valueListenable: selectedCat,
            builder: (context, catIndex, _) {
              return ValueListenableBuilder(
                valueListenable: searchText,
                builder: (context, query, _) {
                  var items = allItems;

                  if (catIndex != 0) {
                    items = allItems
                        .where(
                          (item) =>
                              item.categoryId ==
                              categories[catIndex].categoryId,
                        )
                        .toList();
                  }

                  if (query.isNotEmpty) {
                    items = items
                        .where((item) => item.name.contains(query))
                        .toList();
                  }

                  return ListView.builder(
                    itemCount: items.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ItemCard(
                        item: item,
                        catName: categories
                            .firstWhere(
                              (cat) => cat.categoryId == item.categoryId,
                            )
                            .name,
                        onQuantityChanged: (x) {
                          final orderItem = OrderItemModel()
                            ..itemId = item.itemId
                            ..price = item.price
                            ..quantity = 1;
                          orderProvider.upsertOrderItemLocally(orderItem);
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
