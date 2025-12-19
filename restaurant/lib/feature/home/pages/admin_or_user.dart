import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/feature/home/pages/admin/admin_home_gate.dart';
import 'package:restaurant/feature/home/pages/user_home_page.dart';
import 'package:restaurant/feature/home/provider/fire_store_provider.dart';
import 'package:restaurant/feature/models/user.dart';

class AdminOrUser extends StatelessWidget {
  const AdminOrUser({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel? user = context.watch<FireStoreProvider>().currentUser;
    if (user == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (user.role == 'admin') {
      return AdminHomeGate();
    }

    return UserHomePage();
  }
}
