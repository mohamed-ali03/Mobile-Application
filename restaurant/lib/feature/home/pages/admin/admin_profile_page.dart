import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/feature/auth/provider/auth_provider.dart';
import 'package:restaurant/feature/home/provider/fire_store_provider.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    FireStoreProvider fireStoreProvider = context.read<FireStoreProvider>();
    AuthProvider authProvider = context.read<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
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
    );
  }
}
