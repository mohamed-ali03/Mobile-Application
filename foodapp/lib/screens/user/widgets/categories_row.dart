import 'package:flutter/material.dart';
import 'package:foodapp/models/category%20model/category_model.dart';
import 'package:foodapp/screens/user/widgets/category_tap.dart';

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
