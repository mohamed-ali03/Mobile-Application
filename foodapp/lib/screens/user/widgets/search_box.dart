import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController searchController;
  final ValueNotifier<String> searchText;
  const SearchBox({
    super.key,
    required this.searchController,
    required this.searchText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      onChanged: (value) {
        searchText.value = value.toLowerCase();
      },

      decoration: InputDecoration(
        hintText: 'Search dishes...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
