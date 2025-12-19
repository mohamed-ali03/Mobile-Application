import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/feature/auth/provider/auth_provider.dart';
import 'package:restaurant/feature/home/provider/fire_store_provider.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  late FireStoreProvider fireStoreProvider;
  late AuthProvider authProvider;

  void checkAndListenToAppStatus() async {
    await fireStoreProvider.checkAppStatus();
    if (!mounted) return;
    fireStoreProvider.listenToAppStatus();
  }

  @override
  Widget build(BuildContext context) {
    fireStoreProvider = context.read<FireStoreProvider>();
    authProvider = context.read<AuthProvider>();
    checkAndListenToAppStatus();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              authProvider.logout();
              fireStoreProvider.currentUser = null;
              fireStoreProvider.isUserLoaded = false;
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(child: TextField()),
    );
  }
}
