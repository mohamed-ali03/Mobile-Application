import 'package:flutter/material.dart';
import 'package:foodapp/l10n/app_localizations.dart';
import 'package:foodapp/models/category%20model/category_model.dart';
import 'package:foodapp/models/item%20model/item_model.dart';
import 'package:foodapp/providers/menu_provider.dart';
import 'package:foodapp/screens/admin/widgets/admin_menu_item_dialog.dart';
import 'package:foodapp/screens/widgets/item_card.dart';
import 'package:foodapp/screens/admin/widgets/admin_menu_stats.dart';
import 'package:foodapp/screens/widgets/menu_search_filters.dart';
import 'package:foodapp/screens/admin/widgets/admin_menu_states.dart';
import 'package:provider/provider.dart';

class AdminMenuScreen extends StatefulWidget {
  const AdminMenuScreen({super.key});

  @override
  State<AdminMenuScreen> createState() => _AdminMenuScreenState();
}

class _AdminMenuScreenState extends State<AdminMenuScreen> {
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

  Map<String, int> _calculateStats(List<ItemModel> items) {
    return {
      'total': items.length,
      'available': items.where((item) => item.available).length,
      'outOfStock': items.where((item) => !item.available).length,
    };
  }

  void _showAddItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => MenuItemFormDialog(
        isEdit: false,
        onSave:
            (
              name,
              price,
              description,
              categoryId,
              available,
              imageUrl,
              ingreidents,
            ) {
              final newItem = ItemModel()
                ..name = name
                ..description = description
                ..price = price
                ..categoryId = categoryId
                ..imageUrl = imageUrl
                ..ingreidents = ingreidents
                ..available = available;

              context.read<MenuProvider>().addItem(newItem);
              Navigator.pop(context);
            },
      ),
    );
  }

  void _showEditItemDialog(BuildContext context, ItemModel item) {
    showDialog(
      context: context,
      builder: (context) => MenuItemFormDialog(
        isEdit: true,
        initialItem: item,
        onSave:
            (
              name,
              price,
              description,
              categoryId,
              available,
              imageUrl,
              ingreidents,
            ) {
              final updatedItem = ItemModel()
                ..itemId = item.itemId
                ..name = name
                ..description = description
                ..price = price
                ..categoryId = categoryId
                ..imageUrl = imageUrl.isNotEmpty ? imageUrl : item.imageUrl
                ..ingreidents = ingreidents
                ..available = available;

              context.read<MenuProvider>().updateItem(updatedItem);
              Navigator.pop(context);
            },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).t('menuManagement')),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemDialog(context),
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context).t('addItem')),
      ),
      body: Consumer<MenuProvider>(
        builder: (context, menuProvider, child) {
          if (menuProvider.isLoading && menuProvider.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (menuProvider.items.isEmpty || menuProvider.categories.isEmpty) {
            return AdminMenuEmptyState(
              onAddItem: () => _showAddItemDialog(context),
            );
          }

          final filteredItems = _getFilteredItems(menuProvider.items);
          final stats = _calculateStats(menuProvider.items);

          return CustomScrollView(
            slivers: [
              // Stats Section
              SliverToBoxAdapter(child: AdminMenuStats(stats: stats)),

              // Search and Filters
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

              // Items List
              if (filteredItems.isEmpty)
                SliverFillRemaining(
                  child: AdminMenuNoResultsState(
                    onClearFilters: () {
                      setState(() {
                        _searchQuery = '';
                        _selectedCategoryId = null;
                        _showAvailableOnly = false;
                        _searchController.clear();
                      });
                    },
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = filteredItems[index];
                      final category = menuProvider.categories.firstWhere(
                        (cat) => cat.categoryId == item.categoryId,
                        orElse: () => CategoryModel()
                          ..name = AppLocalizations.of(context).t('unknown')
                          ..categoryId = 0,
                      );

                      return ItemCard(
                        item: item,
                        categoryName: category.name,
                        onEdit: () => _showEditItemDialog(context, item),
                      );
                    }, childCount: filteredItems.length),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
