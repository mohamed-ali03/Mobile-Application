import 'package:flutter/material.dart';
import 'package:foodapp/models/category model/category_model.dart';

class MenuSearchFilters extends StatelessWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final int? selectedCategoryId;
  final bool showAvailableOnly;
  final List<CategoryModel> categories;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<int?> onCategoryChanged;
  final ValueChanged<bool> onAvailableToggle;
  final VoidCallback onClearFilters;

  const MenuSearchFilters({
    required this.searchController,
    required this.searchQuery,
    required this.selectedCategoryId,
    required this.showAvailableOnly,
    required this.categories,
    required this.onSearchChanged,
    required this.onCategoryChanged,
    required this.onAvailableToggle,
    required this.onClearFilters,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final hasFilters =
        searchQuery.isNotEmpty ||
        selectedCategoryId != null ||
        showAvailableOnly;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search items',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        onSearchChanged('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: onSearchChanged,
          ),
          const SizedBox(height: 12),

          // Filters Row
          Row(
            children: [
              // Category Filter
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int?>(
                      value: selectedCategoryId,
                      hint: const Text('All Categories'),
                      isExpanded: true,
                      items: [
                        DropdownMenuItem<int?>(
                          value: null,
                          child: const Text('All Categories'),
                        ),
                        ...categories.map(
                          (cat) => DropdownMenuItem<int?>(
                            value: cat.categoryId,
                            child: Text(cat.name),
                          ),
                        ),
                      ],
                      onChanged: onCategoryChanged,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Available Filter
              FilterChip(
                label: const Text('Available Only'),
                selected: showAvailableOnly,
                onSelected: onAvailableToggle,
              ),
            ],
          ),

          // Clear Filters Button
          if (hasFilters)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextButton.icon(
                onPressed: onClearFilters,
                icon: const Icon(Icons.clear_all, size: 16),
                label: const Text("Clear Filters"),
                style: TextButton.styleFrom(foregroundColor: Colors.blue),
              ),
            ),
        ],
      ),
    );
  }
}
