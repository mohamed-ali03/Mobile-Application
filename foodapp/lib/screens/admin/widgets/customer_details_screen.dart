import 'package:flutter/material.dart';
import 'package:foodapp/l10n/app_localizations.dart';
import 'package:foodapp/models/user model/user_model.dart';

class CustomerDetailsScreen extends StatelessWidget {
  final UserModel user;

  const CustomerDetailsScreen({super.key, required this.user});

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).t('customerDetails')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundImage:
                  user.imageUrl != null && user.imageUrl!.isNotEmpty
                  ? NetworkImage(user.imageUrl!) as ImageProvider
                  : null,
              child: (user.imageUrl == null || user.imageUrl!.isEmpty)
                  ? Text(user.name.isNotEmpty ? user.name[0].toUpperCase() : '')
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).t(user.role).toUpperCase(),
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: Text(
                  user.phoneNumber ??
                      AppLocalizations.of(context).t('notProvided'),
                ),
                subtitle: Text(AppLocalizations.of(context).t('phone')),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(_formatDate(user.createdAt)),
                subtitle: Text(AppLocalizations.of(context).t('memberSince')),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // future: call / message
              },
              icon: const Icon(Icons.message),
              label: Text(AppLocalizations.of(context).t('message')),
            ),
          ],
        ),
      ),
    );
  }
}
