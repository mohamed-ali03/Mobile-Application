import 'package:flutter/material.dart';
import 'package:foodapp/l10n/app_localizations.dart';
import 'package:foodapp/models/user model/user_model.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final UserModel user;

  const CustomerDetailsScreen({super.key, required this.user});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
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
                  widget.user.imageUrl != null &&
                      widget.user.imageUrl!.isNotEmpty
                  ? NetworkImage(widget.user.imageUrl!) as ImageProvider
                  : null,
              child:
                  (widget.user.imageUrl == null ||
                      widget.user.imageUrl!.isEmpty)
                  ? Text(
                      widget.user.name.isNotEmpty
                          ? widget.user.name[0].toUpperCase()
                          : '',
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              widget.user.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).t(widget.user.role).toUpperCase(),
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: Text(
                  widget.user.phoneNumber ??
                      AppLocalizations.of(context).t('notProvided'),
                ),
                subtitle: Text(AppLocalizations.of(context).t('phone')),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(_formatDate(widget.user.createdAt)),
                subtitle: Text(AppLocalizations.of(context).t('memberSince')),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.point_of_sale),
                title: Text(widget.user.buyingPoints.toString()),
                subtitle: Text(AppLocalizations.of(context).t('points')),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.block),
                title: Text(
                  widget.user.blocked
                      ? AppLocalizations.of(context).t('blocked')
                      : AppLocalizations.of(context).t('active'),
                ),
                subtitle: Text(AppLocalizations.of(context).t('status')),
                trailing: Switch(
                  value: widget.user.blocked,
                  onChanged: (value) async {
                    await context.read<AuthProvider>().updateProfile(
                      widget.user.authID,
                      blocked: value,
                    );
                    widget.user.blocked = value;
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
