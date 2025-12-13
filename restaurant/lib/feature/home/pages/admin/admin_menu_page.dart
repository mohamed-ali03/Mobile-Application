import 'package:flutter/material.dart';
import 'package:restaurant/feature/home/functions.dart';
import 'package:restaurant/feature/home/pages/admin/item_page.dart';
import 'package:restaurant/feature/home/widgets/admin_custom_fab.dart';
import 'package:restaurant/feature/home/widgets/admin_item_tile.dart';
import 'package:restaurant/feature/home/widgets/admin_tap_bar.dart';
import 'package:restaurant/feature/models/category.dart';
import 'package:restaurant/feature/models/menu.dart';
import 'package:restaurant/feature/models/product_item.dart';

class AdminMenuPage extends StatefulWidget {
  const AdminMenuPage({super.key});

  @override
  State<AdminMenuPage> createState() => _AdminMenuPageState();
}

class _AdminMenuPageState extends State<AdminMenuPage>
    with TickerProviderStateMixin {
  ValueNotifier<bool> isPressedFAB = ValueNotifier(false);
  late TabController _controllerBNB;
  ValueNotifier<int> selectedTapBNB = ValueNotifier(0);

  // Now you can use it in initializers
  Menu menu = Menu(
    categories: [
      Category(
        categoryName: 'Burger',
        items: [
          ProductItem(
            itemName: 'Classic Beef Burger',
            categoryId: '1',
            categoryName: 'Burger',
            price: 20,
            rating: 4.7,
            numOfReviews: 5,
            description:
                'A juicy grilled beef patty topped with melted cheese, fresh lettuce, tomatoes, and our special house sauce, all served in a soft toasted bun.',
            ingredients: ingredientsTemplate(
              beef: true,
              cheese: true,
              lettuce: true,
              tomato: true,
              onion: true,
              sauce: true,
              bread: true,
            ),
          ),
          ProductItem(
            itemName: 'Cheese Burger',
            categoryId: '1',
            categoryName: 'Burger',
            price: 22,
            rating: 4.6,
            numOfReviews: 4,
            description:
                'A juicy grilled beef patty topped with melted cheese, fresh lettuce, tomatoes, and our special house sauce, all served in a soft toasted bun.',
            ingredients: ingredientsTemplate(
              beef: true,
              cheese: true,
              sauce: true,
              bread: true,
            ),
          ),
          ProductItem(
            itemName: 'Chicken Burger',
            categoryId: '1',
            categoryName: 'Burger',
            price: 18,
            rating: 4.5,
            numOfReviews: 3,
            description:
                'A juicy grilled beef patty topped with melted cheese, fresh lettuce, tomatoes, and our special house sauce, all served in a soft toasted bun.',
            ingredients: ingredientsTemplate(
              chicken: true,
              cheese: true,
              lettuce: true,
              sauce: true,
              bread: true,
            ),
          ),
        ],
      ),
      Category(
        categoryName: 'Pizza',
        items: [
          ProductItem(
            itemName: 'Margherita Pizza',
            categoryId: '2',
            categoryName: 'Pizza',
            price: 25,
            rating: 4.6,
            numOfReviews: 6,
            description:
                'Crispy baked dough layered with rich tomato sauce, melted mozzarella cheese, and generous slices of pepperoni for a bold, savory flavor.',
            ingredients: ingredientsTemplate(
              cheese: true,
              dough: true,
              sauce: true,
            ),
          ),
          ProductItem(
            itemName: 'Pepperoni Pizza',
            categoryId: '2',
            categoryName: 'Pizza',
            price: 30,
            rating: 4.7,
            numOfReviews: 7,
            description:
                'Crispy baked dough layered with rich tomato sauce, melted mozzarella cheese, and generous slices of pepperoni for a bold, savory flavor',
            ingredients: ingredientsTemplate(
              beef: true,
              cheese: true,
              dough: true,
              sauce: true,
            ),
          ),
          ProductItem(
            itemName: 'Chicken BBQ Pizza',
            categoryId: '2',
            categoryName: 'Pizza',
            price: 32,
            rating: 4.5,
            numOfReviews: 5,
            description:
                'Crispy baked dough layered with rich tomato sauce, melted mozzarella cheese, and generous slices of pepperoni for a bold, savory flavor',
            ingredients: ingredientsTemplate(
              chicken: true,
              cheese: true,
              dough: true,
              sauce: true,
            ),
          ),
        ],
      ),
      Category(
        categoryName: 'Drinks',
        items: [
          ProductItem(
            itemName: 'Milkshake',
            categoryId: '3',
            categoryName: 'Drinks',
            price: 12,
            rating: 4.7,
            numOfReviews: 7,
            description:
                'Smooth cold-brewed coffee mixed with fresh milk and lightly sweetened, served chilled for a refreshing boost.',
            ingredients: ingredientsTemplate(milk: true, sugar: true),
          ),
          ProductItem(
            itemName: 'Fresh Juice',
            categoryId: '3',
            categoryName: 'Drinks',
            price: 7,
            rating: 4.4,
            numOfReviews: 6,
            description:
                'Smooth cold-brewed coffee mixed with fresh milk and lightly sweetened, served chilled for a refreshing boost.',
            ingredients: ingredientsTemplate(sugar: true),
          ),
          ProductItem(
            itemName: 'Iced Coffee',
            categoryId: '3',
            categoryName: 'Drinks',
            price: 10,
            rating: 4.6,
            numOfReviews: 8,
            description:
                'Smooth cold-brewed coffee mixed with fresh milk and lightly sweetened, served chilled for a refreshing boost.',
            ingredients: ingredientsTemplate(milk: true, sugar: true),
          ),
        ],
      ),
    ],
  );
  @override
  void initState() {
    super.initState();
    _controllerBNB = TabController(
      length: menu.categories!.length + 1, // +1 for "All"
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controllerBNB.dispose();
    super.dispose();
  }

  void onTapBNB(int index) {
    selectedTapBNB.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Menu',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        bottom: adminTabBar(_controllerBNB, onTapBNB, [
          'All',
          ...?menu.categories?.map((cat) => cat.categoryName!),
        ]),
      ),

      floatingActionButton: AdminCustomFab(isPressed: isPressedFAB),

      body: ValueListenableBuilder(
        valueListenable: selectedTapBNB,
        builder: (context, value, _) {
          if (value == 0) {
            return _showMenu(menu.categories ?? []);
          } else {
            return _showCategoryItems(menu.categories![value - 1]);
          }
        },
      ),
    );
  }

  Widget _showMenu(List<Category> categories) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        Category category = categories[index];
        return _showCategoryItems(category);
      },
    );
  }

  Widget _showCategoryItems(Category category) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Category Title
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              category.categoryName!,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),

          /// Items inside the category
          ListView.builder(
            itemCount: category.items?.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, itemIndex) {
              ProductItem item = category.items![itemIndex];
              return Column(
                children: [
                  AdminItemTile(
                    item: item,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemPage(item: item),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
