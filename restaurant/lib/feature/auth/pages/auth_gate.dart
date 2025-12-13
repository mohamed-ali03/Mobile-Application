import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/feature/auth/pages/register_or_login.dart';
import 'package:restaurant/feature/home/pages/admin/admin_home_gate.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AdminHomeGate();
        } else {
          return RegisterOrLogin();
        }
      },
    );
  }
}
