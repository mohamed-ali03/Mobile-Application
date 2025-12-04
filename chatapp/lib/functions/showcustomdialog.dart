import 'package:flutter/material.dart';

void showCustomDialog(String text, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(content: Text(text)),
  );
}
