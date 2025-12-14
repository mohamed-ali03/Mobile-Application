import 'package:flutter/material.dart';
import 'package:restaurant/core/widgets/custom_en_tf.dart';

class InputField extends StatelessWidget {
  final String title;
  final String hint;
  final int? numOfLines;
  final TextEditingController controller;
  final bool numbersOnly;
  const InputField({
    super.key,
    required this.title,
    required this.hint,
    required this.controller,
    this.numOfLines,
    this.numbersOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 5),
        CustomEnTF(
          controller: controller,
          hint: hint,
          numOfLines: numOfLines,
          numbersOnly: numbersOnly,
        ),
      ],
    );
  }
}
