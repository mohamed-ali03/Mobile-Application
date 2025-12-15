import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/feature/auth/pages/register_or_login.dart';
import 'package:restaurant/feature/home/pages/admin/admin_home_gate.dart';
import 'package:restaurant/feature/home/pages/user_home_page.dart';
import 'package:restaurant/feature/home/provider/app_provider.dart';
import 'package:restaurant/feature/models/user.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 🔄 Loading auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ❌ Not logged in
        if (!snapshot.hasData || snapshot.data!.uid.isEmpty) {
          return const RegisterOrLogin();
        }

        final uid = snapshot.data?.uid;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(seconds: 5), () {
            if (!context.mounted) return;
            context.read<AppProvider>().getUserByID(uid!);
          });
        });

        return Selector<AppProvider, UserModel?>(
          selector: (_, provider) => provider.currentUser,
          builder: (context, user, _) {
            if (user == null) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            if (user.uid == null) {
              return const RegisterOrLogin();
            }

            if (user.role == 'admin') {
              return const AdminHomeGate();
            } else {
              return const UserHomePage();
            }
          },
        );
      },
    );
  }
}
