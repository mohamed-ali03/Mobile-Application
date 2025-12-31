import 'package:flutter/material.dart';
import 'package:foodapp/models/category model/category_model.dart';

class CategoryTap extends StatelessWidget {
  final CategoryModel cat;
  final VoidCallback? onTap;
  final bool selected;
  const CategoryTap({
    super.key,
    required this.cat,
    this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.red[100] : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: NetworkImage(cat.imageUrl),
              onBackgroundImageError: (_, _) {},
              child: cat.imageUrl.isEmpty
                  ? const Icon(Icons.fastfood, size: 18)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                cat.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
