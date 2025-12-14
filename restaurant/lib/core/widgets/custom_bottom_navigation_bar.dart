import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final void Function(int)? onTabChange;
  final int selectedIndex;

  const CustomBottomNavigationBar({
    super.key,
    required this.onTabChange,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: GNav(
        selectedIndex: selectedIndex,
        backgroundColor: Colors.transparent,
        tabBackgroundColor: Colors.grey.shade100,
        color: Colors.grey[400],
        activeColor: Colors.orange,
        tabBorderRadius: 16,
        mainAxisAlignment: MainAxisAlignment.center,
        onTabChange: onTabChange,
        tabs: const [
          GButton(icon: Icons.home, text: 'Home'),
          GButton(icon: Icons.menu, text: 'Menu'),
          GButton(icon: Icons.shopping_bag, text: 'Cart'),
          GButton(icon: Icons.person, text: 'Profile'),
        ],
      ),
    );
  }
}
