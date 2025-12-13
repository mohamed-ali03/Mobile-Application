import 'package:flutter/material.dart';

Widget showItemPicture() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Image.asset('assets/image/burger.jpeg', fit: BoxFit.cover),
  );
}

Map<String, bool> ingredientsTemplate({
  bool beef = false,
  bool chicken = false,
  bool cheese = false,
  bool lettuce = false,
  bool tomato = false,
  bool onion = false,
  bool sauce = false,
  bool bread = false,
  bool dough = false,
  bool milk = false,
  bool sugar = false,
}) {
  return {
    'Beef': beef,
    'Chicken': chicken,
    'Cheese': cheese,
    'Lettuce': lettuce,
    'Tomato': tomato,
    'Onion': onion,
    'Sauce': sauce,
    'Bread': bread,
    'Dough': dough,
    'Milk': milk,
    'Sugar': sugar,
  };
}
