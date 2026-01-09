import 'package:flutter/material.dart';
import 'package:foodapp/providers/menu_provider.dart';
import 'package:foodapp/providers/order_provider.dart';
import 'package:foodapp/screens/admin/widgets/admin_home_recent_activity.dart';
import 'package:foodapp/screens/widgets/my_drawer.dart';
import 'package:foodapp/screens/widgets/welcome_box.dart';
import 'package:foodapp/screens/admin/widgets/admin_home_stats.dart';
import 'package:foodapp/screens/admin/widgets/admin_home_quick_action.dart';
import 'package:provider/provider.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text('Admin Dashboard'), elevation: 0),
      drawer: const MyDrawer(),
      body: SafeArea(
        child: Consumer2<OrderProvider, MenuProvider>(
          builder: (context, orderProvider, menuProvider, child) {
            return RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  orderProvider.fetchAllOrders(),
                  menuProvider.sync(),
                ]);
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    const WelcomeBox(),
                    const SizedBox(height: 24),

                    // Stats Cards
                    AdminStatsGrid(
                      orders: orderProvider.orders,
                      menuItems: menuProvider.items,
                    ),
                    const SizedBox(height: 24),

                    // Quick Actions
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AdminQuickActionsGrid(parentContext: context),
                    const SizedBox(height: 24),

                    // Recent Activity
                    Text(
                      'Recent Activity',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    RecentActivityCard(orders: orderProvider.orders),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
