import 'package:flutter/material.dart';
import 'package:foodapp/models/category%20model/category_model.dart';

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

class CategoriesRow extends StatelessWidget {
  final ValueNotifier<int> selCategory;
  final List<CategoryModel> catList;
  const CategoriesRow({
    super.key,
    required this.selCategory,
    required this.catList,
  });

  @override
  Widget build(BuildContext context) {
    List<CategoryModel> cats = [
      CategoryModel()
        ..categoryId = 0
        ..name = 'All'
        ..imageUrl = '',
      ...catList,
    ];

    return Container(
      height: 60,
      color: Colors.grey[100],
      child: ValueListenableBuilder(
        valueListenable: selCategory,
        builder: (context, value, child) {
          return GridView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cats.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 10,
              childAspectRatio: 0.4,
            ),
            itemBuilder: (context, index) {
              return CategoryTap(
                cat: cats[index],
                selected: value == index,
                onTap: () {
                  selCategory.value = index;
                },
              );
            },
          );
        },
      ),
    );
  }
}
