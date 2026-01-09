import 'package:flutter/material.dart';
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
                  title: const Text('Home'),
                  onTap: () => Navigator.pop(context),
                ),

                if (user.role != 'user')
                  ListTile(
                    leading: const Icon(Icons.menu_book),
                    title: const Text('Manage Menu'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/adminMenuScreen');
                    },
                  ),

                ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: const Text('Orders'),
                  onTap: () {
                    Navigator.pop(context);
                    user.role == 'user'
                        ? Navigator.pushNamed(context, '/userCartScreen')
                        : Navigator.pushNamed(context, '/adminOrdersScreen');
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/accountScreen');
                  },
                ),

                // Admin-only section
                if (user.role == 'admin')
                  Column(
                    children: [
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Administration',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.group),
                        title: const Text('Manage Users'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/adminUsersScreen');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text('Settings'),
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
