import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:foodapp/l10n/app_localizations.dart';
import 'package:foodapp/providers/app_settings_provider.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:foodapp/providers/menu_provider.dart';
import 'package:foodapp/providers/order_provider.dart';
import 'package:foodapp/screens/admin/admin_home_screen.dart';
import 'package:foodapp/screens/admin/admin_menu_screen.dart';
import 'package:foodapp/screens/admin/admin_order_screen.dart';
import 'package:foodapp/screens/admin/admin_settings_screen.dart';
import 'package:foodapp/screens/admin/admin_users_screen.dart';
import 'package:foodapp/screens/common/login_screen.dart';
import 'package:foodapp/screens/common/settings_screen.dart';
import 'package:foodapp/screens/staff/staff_home_screen.dart';
import 'package:foodapp/screens/common/account_screen.dart';
import 'package:foodapp/screens/staff/staff_orders_screen.dart';
import 'package:foodapp/screens/user/user_cart_screen.dart';
import 'package:foodapp/screens/user/user_home_screen.dart';
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
        ChangeNotifierProvider(create: (context) => AppSettingsProvider()),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          create: (context) => OrderProvider('user'),
          update: (context, authProvider, orderProvider) {
            return OrderProvider(authProvider.user?.role);
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
    return Consumer<AppSettingsProvider>(
      builder: (context, appSettingsProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Food App',
          routes: {
            '/userHomeScreen': (context) => UserHomeScreen(),
            '/userCartScreen': (context) => UserCartScreen(),
            '/accountScreen': (context) => AccountScreen(),
            '/adminMenuScreen': (context) => AdminMenuScreen(),
            '/adminOrdersScreen': (context) => AdminOrderScreen(),
            '/adminUsersScreen': (context) => const AdminUsersScreen(),
            '/adminSettingsScreen': (context) => const AdminSettingsScreen(),
            '/staffHomeScreen': (context) => const StaffHomeScreen(),
            '/staffOrdersScreen': (context) => const StaffOrdersScreen(),
            '/settings': (context) => const SettingsScreen(),
          },
          locale: Locale(appSettingsProvider.lang),
          supportedLocales: const [Locale('en'), Locale('ar')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
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
      },
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
        return const UserHomeScreen();
    }
  }
}
