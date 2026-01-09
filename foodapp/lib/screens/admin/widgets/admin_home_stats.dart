import 'package:flutter/material.dart';
import 'package:foodapp/models/order%20model/order_model.dart';

class AdminStatsGrid extends StatelessWidget {
  final List<OrderModel> orders;
  final List menuItems;

  const AdminStatsGrid({
    required this.orders,
    required this.menuItems,
    super.key,
  });

  Map<String, dynamic> _calculateStats() {
    final pendingOrders = orders
        .where((o) => o.status.toLowerCase() == 'pending')
        .length;
    final revenue = orders
        .where((o) => o.status.toLowerCase() == 'delivered')
        .fold<double>(0.0, (sum, order) => sum + order.totalPrice);

    return {
      'totalOrders': orders.length,
      'pendingOrders': pendingOrders,
      'menuItems': menuItems.length,
      'revenue': revenue,
    };
  }

  @override
  Widget build(BuildContext context) {
    final stats = _calculateStats();

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _StatCard(
          title: 'Total Orders',
          value: stats['totalOrders'].toString(),
          icon: Icons.shopping_bag,
          color: Colors.green,
        ),
        _StatCard(
          title: 'Pending Orders',
          value: stats['pendingOrders'].toString(),
          icon: Icons.pending_actions,
          color: Colors.orange,
        ),
        _StatCard(
          title: 'Menu Items',
          value: stats['menuItems'].toString(),
          icon: Icons.restaurant_menu,
          color: Colors.blue,
        ),
        _StatCard(
          title: 'Revenue',
          value: '${stats['revenue'].toStringAsFixed(0)} EGP',
          icon: Icons.attach_money,
          color: Colors.purple,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
