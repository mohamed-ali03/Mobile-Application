import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/feature/auth/pages/register_or_login.dart';
import 'package:restaurant/feature/auth/provider/auth_provider.dart';
import 'package:restaurant/feature/home/pages/admin_or_user.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().authUser;
    return user == null ? RegisterOrLogin() : AdminOrUser();
  }
}
