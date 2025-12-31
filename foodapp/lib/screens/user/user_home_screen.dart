import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:foodapp/providers/menu_provider.dart';
import 'package:foodapp/screens/user/widgets/categories_row.dart';
import 'package:foodapp/screens/user/widgets/menu_items_by_category.dart';
import 'package:foodapp/widgets/my_drawer.dart';
import 'package:foodapp/screens/user/widgets/search_box.dart';
import 'package:provider/provider.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final searchController = TextEditingController();
  ValueNotifier<String> searchText = ValueNotifier('');
  ValueNotifier<int> selectedCat = ValueNotifier(0);

  @override
  void dispose() {
    searchController.dispose();
    searchText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: const MyDrawer(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              pinned: false,
              actions: [
                IconButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/userCartScreen'),
                  icon: const Icon(Icons.shopping_cart),
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _WelcomeBox(),
                    const SizedBox(height: 16),
                    SearchBox(
                      searchController: searchController,
                      searchText: searchText,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            Consumer<MenuProvider>(
              builder: (context, value, child) {
                return SliverStickyHeader(
                  header: CategoriesRow(
                    selCategory: selectedCat,
                    catList: value.categories,
                  ),

                  sliver: SliverPadding(
                    padding: const EdgeInsets.only(top: 20),
                    sliver: SliverToBoxAdapter(
                      child: MenuItemsByCategory(
                        selCategory: selectedCat,
                        searchTxt: searchText,
                        allItems: value.items,
                        categories: value.categories,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeBox extends StatelessWidget {
  const _WelcomeBox();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome 👋', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 4),
        Text(
          '${context.read<AuthProvider>().user?.name}',
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
}
