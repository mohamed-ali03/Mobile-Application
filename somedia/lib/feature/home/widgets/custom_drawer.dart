import 'package:flutter/material.dart';
import 'package:somedia/core/utils/size_config.dart';
import 'package:somedia/feature/auth/auth_service/auth_service.dart';
import 'package:somedia/feature/home/widgets/drawer_list_tile.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  void goHome(BuildContext context) {
    Navigator.pop(context);
  }

  void goMyAccount(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/accountpage');
  }

  void goMySettings(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/settingspage');
  }

  void logout() {
    AuthService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // app icon
              DrawerHeader(
                child: Icon(Icons.people, size: SizeConfig.defaultSize! * 5),
              ),

              // home listtile
              DrawerListTile(
                onTap: () => goHome(context),
                text: 'Home',
                icon: Icon(Icons.home),
              ),

              // account listile
              DrawerListTile(
                onTap: () => goMyAccount(context),
                text: 'Account',
                icon: Icon(Icons.person),
              ),

              // settings listtile
              DrawerListTile(
                onTap: () => goMySettings(context),
                text: 'Settings',
                icon: Icon(Icons.settings),
              ),
            ],
          ),
          // logout listtile
          Padding(
            padding: EdgeInsets.only(bottom: SizeConfig.defaultSize!),
            child: DrawerListTile(
              onTap: logout,
              text: 'Logout',
              icon: Icon(Icons.logout),
            ),
          ),
        ],
      ),
    );
  }
}
