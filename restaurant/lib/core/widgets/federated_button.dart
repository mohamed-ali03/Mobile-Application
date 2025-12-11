import 'package:flutter/material.dart';

class FederatedButton extends StatelessWidget {
  final Function()? onTap;
  final Widget widget;
  const FederatedButton({super.key, required this.onTap, required this.widget});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        width: 70,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: widget,
      ),
    );
  }
}
