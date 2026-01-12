import 'package:flutter/material.dart';
import 'package:foodapp/l10n/app_localizations.dart';
import 'package:foodapp/models/user model/user_model.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  @override
  void initState() {
    super.initState();
    // Load users when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().fetchAllUsers();
    });
  }

  Future<void> _changeRole(BuildContext context, UserModel user) async {
    final auth = context.read<AuthProvider>();
    final currentRole = user.role;
    final roles = ['user', 'staff', 'admin'];

    final selected = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(
          '${AppLocalizations.of(context).t('changeRoleTo')} ${user.name}',
        ),
        children: roles
            .map(
              (r) => SimpleDialogOption(
                onPressed: () => Navigator.pop(ctx, r),
                child: Row(
                  children: [
                    Icon(
                      r == currentRole ? Icons.check_circle : Icons.circle,
                      color: r == currentRole ? Colors.blue : Colors.grey,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context).t(r).toUpperCase()),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );

    if (selected == null || selected == currentRole) return;

    try {
      await auth.changeUserRole(user.authID, selected);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.of(context).t('roleUpdatedTo')} $selected ${AppLocalizations.of(context).t('for')}${user.name}',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.of(context).t('failedToUpdateRole')} $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).t('manageUsers')),
        elevation: 0,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isLoading && auth.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = auth.users;

          if (users.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.group_off, size: 56, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text(
                      AppLocalizations.of(context).t('noUsersFound'),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => auth.fetchAllUsers(),
                      child: Text(AppLocalizations.of(context).t('retry')),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => auth.fetchAllUsers(),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: users.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final user = users[index];
                return _UserTile(
                  user: user,
                  onChangeRole: () => _changeRole(context, user),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback onChangeRole;

  const _UserTile({required this.user, required this.onChangeRole});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundImage: user.imageUrl != null && user.imageUrl!.isNotEmpty
              ? NetworkImage(user.imageUrl!) as ImageProvider
              : null,
          child: user.imageUrl == null || user.imageUrl!.isEmpty
              ? Text(user.name.isNotEmpty ? user.name[0].toUpperCase() : '?')
              : null,
        ),
        title: Text(user.name),
        subtitle: Text(
          '${AppLocalizations.of(context).t('role')}: ${user.role}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onChangeRole,
        ),
      ),
    );
  }
}
