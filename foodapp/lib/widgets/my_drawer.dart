import 'package:flutter/material.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:foodapp/screens/common/account_screen.dart';
import 'package:foodapp/screens/user/user_cart_screen.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Consumer<AuthProvider>(
                    builder: (context, authprovider, _) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          authprovider.user?.imageUrl == null
                              ? const Icon(
                                  Icons.account_circle,
                                  size: 48,
                                  color: Colors.white,
                                )
                              : CircleAvatar(
                                  radius: 40, // size
                                  backgroundImage: NetworkImage(
                                    authprovider.user?.imageUrl ?? '',
                                  ),
                                  backgroundColor: Colors.grey.shade200,
                                ),
                          Text(
                            authprovider.user?.name ?? 'user',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('My Orders'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserCartScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountScreen()),
                  );
                },
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                context.read<AuthProvider>().logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
