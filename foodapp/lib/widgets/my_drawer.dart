import 'package:flutter/material.dart';
import 'package:foodapp/models/user%20model/user_model.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<AuthProvider>(
        builder: (context, authprovider, _) {
          UserModel? user = authprovider.user;
          if (user == null) {
            return Center(child: Icon(Icons.not_interested_sharp));
          }

          return Column(
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          user.imageUrl == null
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
                            user.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () => Navigator.pop(context),
                  ),
                  if (user.role != 'user')
                    ListTile(
                      leading: const Icon(Icons.menu),
                      title: const Text('Menu'),
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
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<AuthProvider>().logout();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
