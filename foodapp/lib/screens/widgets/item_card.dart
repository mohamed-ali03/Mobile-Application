import 'package:flutter/material.dart';
import 'package:foodapp/l10n/app_localizations.dart';
import 'package:foodapp/models/item%20model/item_model.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:foodapp/screens/widgets/availability_badge.dart';
import 'package:foodapp/screens/widgets/item_details_sheet.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatefulWidget {
  final ItemModel item;
  final String categoryName;
  final ValueChanged<bool>? onSelectItem; // for user mode
  final VoidCallback? onEdit; // for admin/staff

  const ItemCard({
    super.key,
    required this.item,
    required this.categoryName,
    this.onSelectItem,
    this.onEdit,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthProvider>().user?.role ?? 'user';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => showItemDetails(
          context,
          item: widget.item,
          categoryName: widget.categoryName,
          onSelectItem: widget.onSelectItem,
          onEdit: widget.onEdit,
          selected: selected,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.item.imageUrl,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 96,
                        height: 96,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  widget.categoryName,
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${AppLocalizations.of(context).t("egp")} ${widget.item.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            AvailabilityBadge(available: widget.item.available),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: role == 'user'
                    ? [
                        Text(
                          '${AppLocalizations.of(context).t('price')}: ${AppLocalizations.of(context).t("egp")}${widget.item.price.toStringAsFixed(2)}',
                        ),
                        const SizedBox(width: 12),
                        widget.item.available
                            ? selected
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          selected = false;
                                          widget.onSelectItem!(selected);
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        setState(() {
                                          selected = true;
                                          widget.onSelectItem!(selected);
                                        });
                                      },
                                      icon: const Icon(Icons.add_shopping_cart),
                                    )
                            : IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.block,
                                  color: Colors.red,
                                ),
                              ),
                      ]
                    : [
                        if (widget.onEdit != null)
                          TextButton.icon(
                            onPressed: widget.onEdit,
                            icon: const Icon(Icons.edit, size: 18),
                            label: Text(AppLocalizations.of(context).t('edit')),
                          ),
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
