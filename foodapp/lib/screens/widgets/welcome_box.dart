import 'package:flutter/material.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:provider/provider.dart';

/// A unified welcome box that adapts to user role (user, admin, staff).
class WelcomeBox extends StatelessWidget {
  final String? titleOverride;
  final String? subtitleOverride;
  const WelcomeBox({super.key, this.titleOverride, this.subtitleOverride});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final role = auth.user?.role ?? 'user';
    final name = auth.user?.name ?? (role == 'admin' ? "admin" : "user");

    final title =
        titleOverride ??
        (role == 'admin' ? "Welcome, $name!" : "Welcome, $name!");
    final subtitle =
        subtitleOverride ??
        (role == 'admin'
            ? "Manage your restaurant"
            : "Explore delicious meals");

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
