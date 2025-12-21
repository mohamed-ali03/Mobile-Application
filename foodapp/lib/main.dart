import 'package:flutter/material.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:foodapp/providers/menu_provider.dart';
import 'package:foodapp/providers/order_provider.dart';
import 'package:foodapp/screens/admin/menu_screen.dart';
import 'package:foodapp/screens/admin/admin_home_screen.dart';
import 'package:foodapp/screens/common/login_screen.dart';
import 'package:foodapp/screens/staff/staff_home_screen.dart';
import 'package:foodapp/service/isar_local/isar_service.dart';
import 'package:foodapp/service/supabase_remote/supabase_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize supabase (remote DB)
  await SupabaseService.init();

  // Initialize isar (local DB)
  await IsarService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => MenuProvider()),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          create: (context) => OrderProvider(null),
          update: (context, authProvider, orderProvider) {
            return OrderProvider(authProvider.user);
          },
        ),
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
      title: 'Food App',
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.blue),
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          // Loading state
          if (authProvider.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Not authenticated
          if (authProvider.user == null) {
            return const LoginScreen();
          }

          // Role-based routing
          return _buildHomeScreen(authProvider.user!.role);
        },
      ),
    );
  }

  /// Build home screen based on user role
  Widget _buildHomeScreen(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return const AdminHomeScreen();
      case 'staff':
        return const StaffHomeScreen();
      case 'user':
      default:
        return const MenuScreen();
    }
  }
}
