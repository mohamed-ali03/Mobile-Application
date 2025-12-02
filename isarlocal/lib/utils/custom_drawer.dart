import 'package:flutter/material.dart';
import 'package:isarlocal/utils/custom_drawer_listTile.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          DrawerHeader(child: Icon(Icons.edit)),

          CustomDrawerListtile(
            text: 'Notes',
            icon: Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/notespage');
            },
          ),
          CustomDrawerListtile(
            text: 'Settings',
            icon: Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settingspage');
            },
          ),
        ],
      ),
    );
  }
}
