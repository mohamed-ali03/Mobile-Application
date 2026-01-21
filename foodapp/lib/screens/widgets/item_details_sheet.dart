import 'package:flutter/material.dart';
import 'package:foodapp/models/item%20model/item_model.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:foodapp/screens/widgets/availability_badge.dart';
import 'package:provider/provider.dart';

void showItemDetails(
  BuildContext context, {
  required ItemModel item,
  required String categoryName,
  ValueChanged<bool>? onSelectItem,
  VoidCallback? onEdit,
  bool selected = false,
  bool needButton = true,
}) {
  final rawIngredients = (item.ingreidents).trim();
  final ingredients = rawIngredients.isEmpty
      ? <String>[]
      : rawIngredients
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      final role = context.read<AuthProvider>().user?.role ?? 'user';
      return ItemDetailsSheet(
        item: item,
        categoryName: categoryName,
        onSelectItem: onSelectItem,
        onEdit: onEdit,
        ingredients: ingredients,
        role: role,
        selected: selected,
        needButton: needButton,
      );
    },
  );
}

class ItemDetailsSheet extends StatefulWidget {
  final ItemModel item;
  final String categoryName;
  final String role;
  final List<String> ingredients;
  final ValueChanged<bool>? onSelectItem;
  final VoidCallback? onEdit;
  final bool selected;
  final bool needButton;

  const ItemDetailsSheet({
    super.key,
    required this.item,
    required this.role,
    required this.ingredients,
    required this.categoryName,
    this.onSelectItem,
    this.onEdit,
    this.selected = false,
    this.needButton = true,
  });

  @override
  State<ItemDetailsSheet> createState() => _ItemDetailsSheetState();
}

class _ItemDetailsSheetState extends State<ItemDetailsSheet> {
  late bool _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              if (widget.item.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      widget.item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                widget.item.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              AvailabilityBadge(available: widget.item.available),
              const SizedBox(height: 12),
              Text(
                widget.item.description,
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 12),
              if (widget.ingredients.isNotEmpty) ...[
                const Text(
                  'Ingredients',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: widget.ingredients
                      .map(
                        (ing) => Chip(
                          label: Text(ing),
                          backgroundColor: Colors.grey[100],
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'EGP${widget.item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    widget.categoryName,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (widget.needButton)
                Row(
                  children: [
                    Expanded(
                      child: widget.role == 'user'
                          ? ElevatedButton.icon(
                              onPressed: widget.item.available
                                  ? () {
                                      setState(() {
                                        _selected = true;
                                        widget.onSelectItem?.call(_selected);
                                      });
                                      Navigator.pop(context);
                                    }
                                  : null,
                              icon: const Icon(Icons.add_shopping_cart),
                              label: const Text('Add to Cart'),
                            )
                          : OutlinedButton.icon(
                              onPressed: widget.onEdit,
                              icon: const Icon(Icons.edit),
                              label: const Text('Edit'),
                            ),
                    ),
                    const SizedBox(width: 12),
                    if (widget.role == 'user')
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ),
                  ],
                ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
