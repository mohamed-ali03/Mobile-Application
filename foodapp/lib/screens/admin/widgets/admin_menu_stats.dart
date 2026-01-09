import 'package:flutter/material.dart';

class AdminMenuStats extends StatelessWidget {
  final Map<String, int> stats;

  const AdminMenuStats({required this.stats, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            label: 'Total Items',
            value: stats['total']!.toString(),
            icon: Icons.restaurant_menu,
            color: Colors.blue,
          ),
          _StatItem(
            label: 'Available',
            value: stats['available']!.toString(),
            icon: Icons.check_circle,
            color: Colors.green,
          ),
          _StatItem(
            label: 'Out of Stock',
            value: stats['outOfStock']!.toString(),
            icon: Icons.cancel,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
