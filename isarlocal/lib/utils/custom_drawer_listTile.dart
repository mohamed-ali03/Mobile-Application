import 'package:flutter/material.dart';

class CustomDrawerListtile extends StatelessWidget {
  final String text;
  final Widget? icon;
  final Function()? onTap;
  const CustomDrawerListtile({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 10),
        child: ListTile(title: Text(text), leading: icon),
      ),
    );
  }
}
