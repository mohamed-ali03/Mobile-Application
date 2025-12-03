import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habittracker/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: CupertinoSwitch(
        value: Provider.of<ThemeProvider>(context).isDarkMode(),
        onChanged: (_) =>
            Provider.of<ThemeProvider>(context, listen: false).toggleMode(),
      ),
    );
  }
}
