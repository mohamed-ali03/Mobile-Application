import 'package:flutter/material.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().user;
    if (user == null) {
      return Center(child: Text('No data for this user'));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Profile Image
            CircleAvatar(
              radius: 50,
              backgroundImage: user.imageUrl != null
                  ? NetworkImage(user.imageUrl!)
                  : null,
              child: user.imageUrl == null
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),

            const SizedBox(height: 16),

            /// Name
            Text(user.name, style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: 4),

            /// Role
            Text(user.role, style: Theme.of(context).textTheme.bodyMedium),

            const SizedBox(height: 24),

            /// Info Cards
            _infoTile('Phone', user.phoneNumber ?? 'Not provided'),
            _infoTile(
              'Created At',
              user.createdAt != null
                  ? user.createdAt!.toLocal().toString().split('.').first
                  : 'Unknown',
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(title: Text(title), subtitle: Text(value)),
    );
  }
}
