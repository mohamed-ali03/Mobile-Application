import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/core/size_config.dart';
import 'package:restaurant/core/widgets/add_photo.dart';
import 'package:restaurant/core/widgets/custom_en_tf.dart';
import 'package:restaurant/feature/home/pages/admin/supported%20pages/add_update_item_page.dart';
import 'package:restaurant/feature/home/provider/app_provider.dart';

class AdminCustomFab extends StatefulWidget {
  final ValueNotifier<bool> isPressed;
  const AdminCustomFab({super.key, required this.isPressed});

  @override
  State<AdminCustomFab> createState() => _AdminCustomFabState();
}

class _AdminCustomFabState extends State<AdminCustomFab> {
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // watch isPressed to extend to three buttons or keep it one
    return ValueListenableBuilder(
      valueListenable: widget.isPressed,
      builder: (context, value, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // if the user presse the add button open two opisions --> add category , add item
            if (widget.isPressed.value) ...[
              _buildFab('Add new Category', Icons.add, () {
                widget.isPressed.value = false;
                // show dialog for adding new catogry
                addModifyCategoryDialog();
              }),
              const SizedBox(height: 10),
              _buildFab('Add new Item', Icons.add, () {
                widget.isPressed.value = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddOrUpdateItemPage(),
                  ),
                );
              }),
              const SizedBox(height: 10),
            ],
            FloatingActionButton(
              onPressed: () {
                widget.isPressed.value = !widget.isPressed.value;
              },
              backgroundColor: Colors.orange[800],
              child: Icon(
                widget.isPressed.value ? Icons.close : Icons.add,
                size: 30,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFab(
    String label,
    IconData icon,
    VoidCallback onPressed, {
    bool isPrimary = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(label),
        ),
        SizedBox(width: 8),
        FloatingActionButton(
          heroTag: label,
          onPressed: onPressed,
          backgroundColor: isPrimary ? Colors.orange[800] : Colors.orange,
          mini: !isPrimary,
          child: Icon(icon),
        ),
      ],
    );
  }

  void addModifyCategoryDialog() {
    // show dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        elevation: 1,
        // make the edge rounded
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Add New Category',
          style: TextStyle(
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize:
              MainAxisSize.min, // make its height limited to its content
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Upload image
            AddPhoto(
              icon: Icon(
                // icon that will found before add the photo
                Icons.photo,
                color: Colors.orange,
                size: SizeConfig.defaultSize! * 5,
              ),
              folder: 'categories', // category according to supabase bucket
            ),

            const SizedBox(height: 14),

            /// Category name
            CustomEnTF(controller: nameController, hint: 'Category Name'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<AppProvider>().addCategory(
                nameController.text,
                context.read<AppProvider>().imageURL,
              );
              Navigator.pop(context);
            },
            child: Text(
              'Add',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
