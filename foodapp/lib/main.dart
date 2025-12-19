import 'package:flutter/material.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:foodapp/providers/menu_provider.dart';
import 'package:foodapp/screens/admin/menu_screen.dart';
import 'package:foodapp/screens/admin_home_screen.dart';
import 'package:foodapp/screens/auth/login_screen.dart';
import 'package:foodapp/screens/staff_home_screen.dart';
import 'package:foodapp/service/isar_local/isar_service.dart';
import 'package:foodapp/service/supabase_remote/menu_remote_service.dart';
import 'package:foodapp/service/supabase_remote/supabase_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init supabase(remote DB)
  await SupabaseService.init();

  // init isar(local DB)
  await IsarService.init();

  MenuRemoteService.listenToMenuChanges();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => MenuProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer<AuthProvider>(
        builder: (_, auth, _) {
          if (auth.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (auth.user == null) return const LoginScreen();

          switch (auth.user!.role) {
            case 'admin':
              return AdminHomeScreen();
            case 'staff':
              return StaffHomeScreen();
            default:
              return MenuScreen();
          }
        },
      ),
    );
  }
}
