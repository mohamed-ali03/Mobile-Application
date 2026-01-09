import 'package:flutter/material.dart';

class AvailabilityBadge extends StatelessWidget {
  final bool available;

  const AvailabilityBadge({super.key, required this.available});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: available ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        available ? 'Available' : 'Out of Stock',
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
