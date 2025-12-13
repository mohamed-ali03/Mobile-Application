import 'package:flutter/material.dart';
import 'package:restaurant/feature/home/pages/admin/add_update_item_page.dart';

class AdminCustomFab extends StatefulWidget {
  final ValueNotifier<bool> isPressed;
  const AdminCustomFab({super.key, required this.isPressed});

  @override
  State<AdminCustomFab> createState() => _AdminCustomFabState();
}

class _AdminCustomFabState extends State<AdminCustomFab> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.isPressed,
      builder: (context, value, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isPressed.value) ...[
              _buildFab('Add new Category', Icons.add, () {
                widget.isPressed.value = false;
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
          child: Icon(icon),
          backgroundColor: isPrimary ? Colors.orange[800] : Colors.orange,
          mini: !isPrimary,
        ),
      ],
    );
  }
}
