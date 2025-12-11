import 'package:flutter/material.dart';
import 'package:restaurant/core/size_config.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const CustomButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize!),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Center(child: Text(text)),
        ),
      ),
    );
  }
}
