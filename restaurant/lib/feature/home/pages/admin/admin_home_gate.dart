import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/core/widgets/custom_bottom_navigation_bar.dart';
import 'package:restaurant/feature/home/pages/admin/admin_home_page.dart';
import 'package:restaurant/feature/home/pages/admin/admin_menu_page.dart';
import 'package:restaurant/feature/home/pages/admin/admin_orders_page.dart';
import 'package:restaurant/feature/home/pages/admin/admin_profile_page.dart';
import 'package:restaurant/feature/home/provider/app_provider.dart';

class AdminHomeGate extends StatefulWidget {
  const AdminHomeGate({super.key});

  @override
  State<AdminHomeGate> createState() => _AdminHomeGateState();
}

class _AdminHomeGateState extends State<AdminHomeGate> {
  int _selectedPage = 0;
  final List<Widget> _pages = [
    AdminHomePage(),
    AdminMenuPage(),
    AdminOrdersPage(),
    AdminProfilePage(),
  ];

  void _navigateTo(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  void checkAndListenToAppStatus() async {
    await context.read<AppProvider>().checkAppStatus();
    context.read<AppProvider>().listenToAppStatus();
  }

  @override
  Widget build(BuildContext context) {
    checkAndListenToAppStatus();
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        onTabChange: (index) => _navigateTo(index),
        selectedIndex: _selectedPage,
      ),
      body: _pages[_selectedPage],
    );
  }
}
