import 'package:chatapp/services/auth_service/auth_service.dart';
import 'package:chatapp/functions/showcustomdialog.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  void goHomePage(BuildContext context) {
    Navigator.pop(context);
  }

  void goSettingsPage(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/settingspage');
  }

  void logout(BuildContext context) async {
    Navigator.pop(context);
    try {
      await AuthService().signout();
    } catch (e) {
      showCustomDialog(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Icon(
                  Icons.message,
                  size: 50,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: Text(
                    'H O M E',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () => goHomePage(context),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: Text(
                    'S E T T I N G S',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () => goSettingsPage(context),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 20),
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              title: Text(
                'L O G O U T',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => logout(context),
            ),
          ),
        ],
      ),
    );
  }
}
