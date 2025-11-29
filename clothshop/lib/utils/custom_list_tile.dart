import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final IconData? icon;
  final String text;
  final void Function()? onTap;
  const CustomListTile({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20),
      child: ListTile(leading: Icon(icon), title: Text(text), onTap: onTap),
    );
  }
}
