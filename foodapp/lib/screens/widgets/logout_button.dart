import 'package:flutter/material.dart';
import 'package:foodapp/l10n/app_localizations.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:foodapp/providers/order_provider.dart';
import 'package:provider/provider.dart';

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
                    title: Text(AppLocalizations.of(context).t('logout')),
                    content: Text(
                      AppLocalizations.of(context).t('logoutConfirm'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(AppLocalizations.of(context).t('cancel')),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: Text(AppLocalizations.of(context).t('logout')),
                      ),
                    ],
                  ),
                );

                if (confirm == true && context.mounted) {
                  await orderProvider.clearAllData();
                  await authProvider.logout();

                  if (!context.mounted) return;
                  // Clear navigation stack to let main app's consumer handle routing
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
        icon: const Icon(Icons.logout),
        label: Text(
          AppLocalizations.of(context).t('logout'),
          style: TextStyle(fontSize: 16),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: Colors.red, width: 2),
          foregroundColor: Colors.red,
        ),
      ),
    );
  }
}
