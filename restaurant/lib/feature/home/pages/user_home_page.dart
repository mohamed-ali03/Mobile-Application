import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/feature/auth/provider/auth_provider.dart';
import 'package:restaurant/feature/home/provider/app_provider.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              context.read<AppProvider>().currentUser = null;
              context.read<AppProvider>().isUserLoaded = false;
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
