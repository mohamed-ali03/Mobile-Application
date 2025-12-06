// show dialog with provided text

import 'package:flutter/material.dart';

void showCustomDialog(String text, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(text),
      backgroundColor: Theme.of(context).colorScheme.secondary,
    ),
  );
}
