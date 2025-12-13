import 'package:flutter/material.dart';
import 'package:restaurant/core/constants.dart';
import 'package:restaurant/feature/home/functions.dart';
import 'package:restaurant/feature/home/widgets/custom_ingredient_tile.dart';

class IngredientGridView extends StatelessWidget {
  const IngredientGridView({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, bool> ingredients = ingredientsTemplate();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'INGREIDENTS',
          style: TextStyle(fontSize: fontLarge, color: Colors.black),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: ingredients.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return CustomIngredientTile();
            },
          ),
        ),
      ],
    );
  }
}
