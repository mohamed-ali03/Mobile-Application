import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomArTF extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int? numOfLines;
  final bool numbersOnly;
  final bool obscureText;
  const CustomArTF({
    super.key,
    required this.controller,
    required this.hint,
    this.numOfLines,
    this.numbersOnly = false,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      // add controller
      controller: controller,
      maxLines: numOfLines ?? 1, // to change the lines as desired
      keyboardType: numbersOnly ? TextInputType.number : TextInputType.text,
      inputFormatters: numbersOnly
          ? [FilteringTextInputFormatter.digitsOnly]
          : null, // to restrict the input if needed

      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
