import 'package:flutter/material.dart';
import 'package:somedia/core/utils/size_config.dart';

class DrawerListTile extends StatelessWidget {
  final String text;
  final Icon icon;
  final Function()? onTap;
  const DrawerListTile({
    super.key,
    required this.onTap,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: SizeConfig.defaultSize!),
      child: GestureDetector(
        onTap: onTap,
        child: ListTile(
          leading: icon,
          title: Text(
            text,
            style: TextStyle(fontSize: SizeConfig.defaultSize!),
          ),
        ),
      ),
    );
  }
}
