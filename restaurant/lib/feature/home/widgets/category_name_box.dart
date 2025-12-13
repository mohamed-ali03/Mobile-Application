import 'package:flutter/material.dart';
import 'package:restaurant/core/constants.dart';

class CategoryNameBox extends StatelessWidget {
  final String catName;
  const CategoryNameBox({super.key, required this.catName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        catName,
        style: TextStyle(color: Colors.orange[800], fontSize: fontSmall),
      ),
    );
  }
}
