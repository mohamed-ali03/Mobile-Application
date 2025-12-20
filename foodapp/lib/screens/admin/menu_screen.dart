import 'package:flutter/material.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:foodapp/providers/menu_provider.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void addorder() async {}

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('menu'),
        actions: [
          IconButton(onPressed: () => auth.logout(), icon: Icon(Icons.logout)),
          IconButton(onPressed: addorder, icon: Icon(Icons.add)),
        ],
      ),
      body: Consumer<MenuProvider>(
        builder: (_, menu, _) {
          if (menu.syncing) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: menu.items.length,
            itemBuilder: (_, i) {
              final item = menu.items[i];
              return ListTile(
                title: Text(item.name),
                subtitle: Text('${item.price} EGP'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => menu.deleteItem(item),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
