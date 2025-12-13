import 'package:flutter/material.dart';

class AdminCategoryNameTile extends StatelessWidget {
  final String catName;
  const AdminCategoryNameTile({super.key, required this.catName});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      title: Text(
        catName,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      trailing: PopupMenuButton(
        onSelected: (v) {},
        itemBuilder: (context) => const [
          PopupMenuItem(value: 'addnewItem', child: Text("Add Item")),
          PopupMenuItem(value: 'edit', child: Text("Modify")),
          PopupMenuItem(value: 'delete', child: Text("Delete")),
        ],
      ),
    );
  }
}
