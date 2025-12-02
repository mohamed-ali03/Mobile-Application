import 'package:flutter/material.dart';
import 'dart:math';

class NoteTile extends StatelessWidget {
  final String text;
  void Function()? onLongPress;
  NoteTile({super.key, required this.text, required this.onLongPress});

  final List<Color> itemColors = [
    const Color.fromARGB(255, 131, 74, 231),
    const Color.fromARGB(255, 216, 90, 51),
    const Color.fromARGB(255, 238, 221, 71),
    const Color.fromARGB(255, 233, 112, 148),
    const Color.fromARGB(255, 230, 212, 55),
    const Color.fromARGB(255, 98, 228, 65),
  ];

  final random = Random();

  int getIndex() {
    return random.nextInt(10) % itemColors.length;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: itemColors[getIndex()],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(child: Text(text)),
      ),
    );
  }
}
