import 'package:flutter/material.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:foodapp/providers/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:foodapp/screens/common/login_screen.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.read<OrderProvider>();
    final authProvider = context.read<AuthProvider>();
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: authProvider.isLoading
            ? null
            : () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );

                if (confirm == true && context.mounted) {
                  await orderProvider.clearAllData();
                  await authProvider.logout();

                  // Navigate to login screen after successful logout
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  }
                }
              },
        icon: const Icon(Icons.logout),
        label: const Text('Logout', style: TextStyle(fontSize: 16)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: Colors.red, width: 2),
          foregroundColor: Colors.red,
        ),
      ),
    );
  }
}
