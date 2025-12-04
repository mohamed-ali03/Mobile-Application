import 'package:flutter/material.dart';

void showErrorToUser(String code, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: SizedBox(
        height: 50,
        width: 200,
        child: Center(child: Text(code, style: TextStyle(fontSize: 20))),
      ),
    ),
  );
}
