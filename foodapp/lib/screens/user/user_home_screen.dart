import 'package:flutter/material.dart';
import 'package:foodapp/l10n/app_localizations.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/providers/menu_provider.dart';
import 'package:foodapp/providers/order_provider.dart';
import 'package:foodapp/screens/widgets/menu_search_filters.dart';
import 'package:foodapp/screens/widgets/welcome_box.dart';
import 'package:foodapp/screens/user/widgets/user_home_states.dart';
import 'package:foodapp/models/item%20model/item_model.dart';
import 'package:foodapp/models/category%20model/category_model.dart';
import 'package:foodapp/screens/widgets/item_card.dart';
import 'package:provider/provider.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int? _selectedCategoryId;
  bool _showAvailableOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ItemModel> _getFilteredItems(List<ItemModel> items) {
    return items.where((item) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!item.name.toLowerCase().contains(query) &&
            !item.description.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Category filter
      if (_selectedCategoryId != null &&
          item.categoryId != _selectedCategoryId) {
        return false;
      }

      // Availability filter
      if (_showAvailableOnly && !item.available) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(AppLocalizations.of(context).t('welcomeTitle')),
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, '/accountScreen'),
          icon: const Icon(Icons.person),
        ),
        actions: [CartButton()],
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Consumer<MenuProvider>(
          builder: (context, menuProvider, child) {
            // Early full-screen states (match admin menu pattern)
            if (menuProvider.isLoading && menuProvider.items.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (menuProvider.error != null && menuProvider.items.isEmpty) {
              return UserErrorState(
                error: menuProvider.error!,
                onRetry: () => menuProvider.sync(),
              );
            }

            if (menuProvider.items.isEmpty || menuProvider.categories.isEmpty) {
              return UserEmptyState(onRetry: () => menuProvider.sync());
            }

            // Normal content
            final filteredItems = _getFilteredItems(menuProvider.items);

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverToBoxAdapter(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: IntrinsicWidth(child: const WelcomeBox()),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: MenuSearchFilters(
                    searchController: _searchController,
                    searchQuery: _searchQuery,
                    selectedCategoryId: _selectedCategoryId,
                    showAvailableOnly: _showAvailableOnly,
                    categories: menuProvider.categories,
                    onSearchChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                    onCategoryChanged: (value) {
                      setState(() => _selectedCategoryId = value);
                    },
                    onAvailableToggle: (value) {
                      setState(() => _showAvailableOnly = value);
                    },
                    onClearFilters: () {
                      setState(() {
                        _searchQuery = '';
                        _selectedCategoryId = null;
                        _showAvailableOnly = false;
                        _searchController.clear();
                      });
                    },
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = filteredItems[index];
                      final category = menuProvider.categories.firstWhere(
                        (cat) => cat.categoryId == item.categoryId,
                        orElse: () => CategoryModel()
                          ..name = AppLocalizations.of(
                            context,
                          ).t('unknownCategory')
                          ..categoryId = 0,
                      );

                      return ItemCard(
                        item: item,
                        categoryName: category.name,
                        onSelectItem: (selected) async {
                          if (selected) {
                            final orderItem = OrderItemModel()
                              ..itemId = item.itemId
                              ..price = item.price
                              ..quantity = 1;
                            await context
                                .read<OrderProvider>()
                                .upsertOrderItemLocally(orderItem);
                          } else {
                            await context
                                .read<OrderProvider>()
                                .deleteOrderItemLocally(itemId: item.itemId);
                          }
                        },
                      );
                    }, childCount: filteredItems.length),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/userCartScreen'),
          icon: Stack(
            children: [
              Icon(Icons.shopping_cart),
              Positioned(
                right: 0,
                child: Consumer<OrderProvider>(
                  builder: (context, orderProv, child) {
                    final itemCount = orderProv.orderItems
                        .where((item) => item.synced == false)
                        .toList()
                        .length;
                    if (itemCount == 0) {
                      return const SizedBox.shrink();
                    }
                    return Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        itemCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
