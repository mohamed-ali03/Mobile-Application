import 'package:flutter/material.dart';
import 'package:to_do_list/core/size_config.dart';
import 'package:to_do_list/utils/my_button.dart';

class DialogBox extends StatelessWidget {
  final controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  const DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow[200],
      content: Container(
        height: SizeConfig.defaultSize! * 10,
        width: SizeConfig.defaultSize! * 15,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hint: Text('New Task ...'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MyButton(onPressed: onCancel, text: 'Cancel'),
                MyButton(onPressed: onSave, text: 'Save'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
