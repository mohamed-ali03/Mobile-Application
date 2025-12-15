import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/feature/home/pages/admin/supported%20pages/item_page.dart';
import 'package:restaurant/feature/home/provider/app_provider.dart';
import 'package:restaurant/feature/home/widgets/admin_custom_fab.dart';
import 'package:restaurant/feature/home/widgets/admin_item_tile.dart';
import 'package:restaurant/feature/home/widgets/admin_tap_bar.dart';
import 'package:restaurant/feature/models/category.dart';
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
  late AppProvider appProvider;

  // Now you can use it in initializers
  @override
  void initState() {
    super.initState();
    _controllerBNB = TabController(
      length: context.read<AppProvider>().categories.length + 1, // +1 for "All"
      vsync: this,
    );
    appProvider = context.read<AppProvider>();
  }

  // change the selected tap (go to another category) -- used in Bottom navigation bar
  void onTapBNB(int index) {
    selectedTapBNB.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AppProvider, List<Category>>(
      selector: (_, provider) => provider.categories,
      builder: (context, categories, _) {
        return Scaffold(
          // create appbar with tapes for categories naviation
          appBar: _appbar(categories),

          floatingActionButton: AdminCustomFab(isPressed: isPressedFAB),

          // check if no categories founded show msg otherwise show selected category
          body: categories.isEmpty
              ? Center(child: Text('There is no Menu'))
              : ValueListenableBuilder(
                  valueListenable: selectedTapBNB,
                  builder: (context, value, _) {
                    if (value == 0) {
                      // show all categories unber each other
                      return _showMenu(categories);
                    } else {
                      // show only one category
                      return _showCategoryItems(categories[value - 1]);
                    }
                  },
                ),
        );
      },
    );
  }

  AppBar _appbar(List<Category> categories) {
    return AppBar(
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
        ...categories.map((cat) => cat.categoryName),
      ]),
    );
  }

  Widget _showMenu(List<Category> categories) {
    // traverse over all categories
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
              category.categoryName,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),

          /// traverse over all items inside category and if there is not items show msg
          category.items.isEmpty
              ? Center(child: Text('No Items yet'))
              : ListView.builder(
                  itemCount: category.items.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, itemIndex) {
                    ProductItem item = category.items[itemIndex];
                    return Column(
                      children: [
                        // show each item in custom caontainer and if you press the container you will go to itempage that contain the whole data of the item
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
