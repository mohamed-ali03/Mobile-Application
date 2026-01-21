import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/l10n/app_localizations.dart';
import 'package:foodapp/models/user model/user_model.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:foodapp/screens/admin/widgets/customer_details_screen.dart';
import 'package:provider/provider.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

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
            AppLocalizations.of(
              context,
            ).t('roleUpdatedTo', data: {'role': selected, 'name': user.name}),
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(
              context,
            ).t('failedToUpdateRole', data: {'error': e.toString()}),
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

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: users.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final user = users[index];
              return InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerDetailsScreen(user: user),
                  ),
                ),
                child: _UserTile(
                  user: user,
                  onChangeRole: () => _changeRole(context, user),
                ),
              );
            },
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
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundImage:
                  user.imageUrl != null && user.imageUrl!.isNotEmpty
                  ? CachedNetworkImageProvider(user.imageUrl!)
                  : null,
              child: user.imageUrl == null || user.imageUrl!.isEmpty
                  ? Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    )
                  : null,
            ),
            if (user.blocked)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.block, color: Colors.white, size: 12),
                ),
              ),
          ],
        ),
        title: Text(user.name),
        subtitle: Text(
          AppLocalizations.of(context).t(
            'rolePermission',
            data: {
              'role': AppLocalizations.of(context).t(user.role).toUpperCase(),
            },
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onChangeRole,
        ),
      ),
    );
  }
}
