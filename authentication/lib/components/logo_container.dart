import 'package:flutter/material.dart';

class LogoContainer extends StatelessWidget {
  final String imagePath;
  final void Function()? onTap;
  const LogoContainer({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: Image.asset(imagePath)),
      ),
    );
  }
}
