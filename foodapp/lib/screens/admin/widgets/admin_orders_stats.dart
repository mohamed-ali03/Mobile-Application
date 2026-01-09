import 'package:flutter/material.dart';

class AdminOrdersStats extends StatelessWidget {
  final Map<String, int> stats;

  const AdminOrdersStats({required this.stats, super.key});

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
            label: 'Total',
            value: stats['total']!.toString(),
            icon: Icons.receipt_long,
            color: Colors.blue,
          ),
          _StatItem(
            label: 'Pending',
            value: stats['pending']!.toString(),
            icon: Icons.pending,
            color: Colors.orange,
          ),
          _StatItem(
            label: 'Processing',
            value: stats['processing']!.toString(),
            icon: Icons.restaurant,
            color: Colors.blue,
          ),
          _StatItem(
            label: 'Delivered',
            value: stats['delivered']!.toString(),
            icon: Icons.check_circle,
            color: Colors.green,
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
