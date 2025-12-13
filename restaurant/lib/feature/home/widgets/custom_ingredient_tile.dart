import 'package:flutter/material.dart';

class CustomIngredientTile extends StatelessWidget {
  const CustomIngredientTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orange[200],
          ),
          child: Icon(Icons.soap, color: Colors.orange[800]),
        ),
        const SizedBox(height: 5),
        const Text(
          'Ingredient',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
