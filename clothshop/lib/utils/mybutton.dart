import 'package:flutter/material.dart';

class Mybutton extends StatelessWidget {
  final void Function()? onTap;
  final Widget? child;
  const Mybutton({super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Center(child: child),
      ),
    );
  }
}
