import 'package:flutter/material.dart';
import 'package:foodapp/l10n/app_localizations.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:foodapp/screens/widgets/logout_button.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user!;
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Row(
                    children: [
                      user.imageUrl == null || user.imageUrl!.isEmpty
                          ? CircleAvatar(
                              radius: 34,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              child: Text(
                                user.name.isNotEmpty
                                    ? user.name[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : CircleAvatar(
                              radius: 34,
                              backgroundImage: NetworkImage(user.imageUrl!),
                            ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                user.role.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/accountScreen');
                        },
                      ),
                    ],
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.home),
                  title: Text(AppLocalizations.of(context).t('home')),
                  onTap: () => Navigator.pop(context),
                ),

                if (user.role != 'user')
                  ListTile(
                    leading: const Icon(Icons.menu_book),
                    title: Text(AppLocalizations.of(context).t('manageMenu')),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/adminMenuScreen');
                    },
                  ),

                ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: Text(AppLocalizations.of(context).t('orders')),
                  onTap: () {
                    Navigator.pop(context);
                    user.role == 'user'
                        ? Navigator.pushNamed(context, '/userCartScreen')
                        : Navigator.pushNamed(context, '/adminOrdersScreen');
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(AppLocalizations.of(context).t('profile')),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/accountScreen');
                  },
                ),

                // Admin-only section
                if (user.role == 'admin')
                  Column(
                    children: [
                      Divider(),
                      ListTile(
                        leading: const Icon(Icons.group),
                        title: Text(
                          AppLocalizations.of(context).t('manageUsers'),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/adminUsersScreen');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: Text(AppLocalizations.of(context).t('settings')),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/adminSettingsScreen');
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: LogoutButton(),
          ),
        ],
      ),
    );
  }
}
