import 'package:flutter/material.dart';
import 'package:foodapp/core/functions.dart';
import 'package:foodapp/l10n/app_localizations.dart';
import 'package:foodapp/models/user%20model/user_model.dart';
import 'package:foodapp/providers/app_settings_provider.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:foodapp/screens/common/login_screen.dart';
import 'package:foodapp/screens/widgets/logout_button.dart';
import 'package:provider/provider.dart';
import 'package:foodapp/screens/common/widgets/account_profile_header.dart';
import 'package:foodapp/screens/common/widgets/account_info_card.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().user;
    final lang = context.read<AppSettingsProvider>().lang == 'ar' ? 'En' : 'Ar';

    if (user == null) {
      return _EmptyState();
    }
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).t('profile')),
        centerTitle: true,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              context.read<AppSettingsProvider>().setLanguage(
                lang.toLowerCase(),
              );
            },
            child: Text(lang, style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Profile Header Section
              AccountProfileHeader(
                user: user,
                onEditImage: () =>
                    _showEditProfileDialog(context, user, field: 'image'),
              ),
              const SizedBox(height: 24),

              // Information Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    AccountInfoCard(
                      icon: Icons.person,
                      label: AppLocalizations.of(context).t('fullName'),
                      value: user.name,
                      onEdit: () =>
                          _showEditProfileDialog(context, user, field: 'name'),
                    ),
                    const SizedBox(height: 12),
                    AccountInfoCard(
                      icon: Icons.phone,
                      label: AppLocalizations.of(context).t('phoneNumber'),
                      value: user.phoneNumber ?? 'Not provided',
                      onEdit: () =>
                          _showEditProfileDialog(context, user, field: 'phone'),
                    ),
                    const SizedBox(height: 12),
                    AccountInfoCard(
                      icon: Icons.badge,
                      label: AppLocalizations.of(context).t('role'),
                      value: user.role.toUpperCase(),
                      showEdit: false,
                      valueWidget: _RoleBadge(role: user.role),
                    ),
                    const SizedBox(height: 12),
                    AccountInfoCard(
                      icon: Icons.block,
                      label: AppLocalizations.of(context).t('status'),
                      value: user.blocked
                          ? AppLocalizations.of(context).t('blocked')
                          : AppLocalizations.of(context).t('active'),
                      showEdit: false,
                    ),
                    if (user.role == 'user')
                      Column(
                        children: [
                          const SizedBox(height: 12),
                          AccountInfoCard(
                            icon: Icons.badge,
                            label: AppLocalizations.of(context).t('points'),
                            value: user.buyingPoints.toString(),
                            showEdit: false,
                          ),
                        ],
                      ),

                    const SizedBox(height: 12),
                    AccountInfoCard(
                      icon: Icons.calendar_today,
                      label: AppLocalizations.of(context).t('memberSince'),
                      value: _formatDate(user.createdAt),
                      showEdit: false,
                    ),
                    const SizedBox(height: 12),
                    AccountInfoCard(
                      icon: Icons.fingerprint,
                      label: AppLocalizations.of(context).t('userID'),
                      value: '${user.authID.substring(0, 20)}...',
                      showEdit: false,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LogoutButton(),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showEditProfileDialog(
    BuildContext context,
    UserModel user, {
    required String field,
  }) {
    showDialog(
      context: context,
      builder: (context) => _EditProfileDialog(user: user, field: field),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String role;

  // ignore: unused_element_parameter
  const _RoleBadge({required this.role});

  Color _getRoleColor() {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'staff':
        return Colors.orange;
      case 'user':
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getRoleColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getRoleColor(), width: 1),
      ),
      child: Text(
        AppLocalizations.of(context).t(role).toUpperCase(),
        style: TextStyle(
          color: _getRoleColor(),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context).t('noUserData'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).t('unableToLoadUserInfo'),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: Text(AppLocalizations.of(context).t('goToLogin')),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditProfileDialog extends StatefulWidget {
  final UserModel? user;
  final String field;

  const _EditProfileDialog({required this.user, required this.field});

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  late TextEditingController _controller;
  bool _isUploadingImage = false;
  String? _imageUrl;
  final UploadImage _uploadImage = UploadImage();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.field == 'name') {
      _controller = TextEditingController(text: widget.user?.name);
    } else if (widget.field == 'phone') {
      _controller = TextEditingController(text: widget.user?.phoneNumber ?? '');
    } else {
      _controller = TextEditingController();
      _imageUrl = widget.user?.imageUrl;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleImageUpload() async {
    setState(() => _isUploadingImage = true);

    final file = await _uploadImage.pickImage();
    if (!mounted || file == null) {
      setState(() => _isUploadingImage = false);
      return;
    }

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    _imageUrl = await _uploadImage.uploadImage('user_pic', fileName, file);

    if (mounted) {
      if (_imageUrl!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).t('failedToUploadImage'),
            ),
          ),
        );
      }
      setState(() => _isUploadingImage = false);
    }
  }

  void _save() async {
    if (widget.field == 'image') {
      if (_imageUrl != null && _imageUrl!.isNotEmpty) {
        await context.read<AuthProvider>().updateProfile(
          widget.user?.authID ?? '',
          imageUrl: _imageUrl,
        );
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context).t('profilePictureUpdated'),
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    if (widget.field == 'name') {
      await context.read<AuthProvider>().updateProfile(
        widget.user?.authID ?? '',
        name: _controller.text,
      );
    } else if (widget.field == 'phone') {
      await context.read<AuthProvider>().updateProfile(
        widget.user?.authID ?? '',
        phoneNumber: _controller.text.isEmpty ? null : _controller.text,
      );
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).t('profileUpdatedSuccessfully'),
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.field == 'image') {
      return AlertDialog(
        title: Text(AppLocalizations.of(context).t('updateProfilePicture')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 200,
                height: _imageUrl != null && _imageUrl!.isNotEmpty ? null : 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[100],
                ),
                child: _imageUrl != null && _imageUrl!.isNotEmpty
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(_imageUrl!, fit: BoxFit.cover),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _imageUrl = null;
                              });
                            },
                            icon: Icon(
                              Icons.highlight_remove_sharp,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: _isUploadingImage ? null : _handleImageUpload,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isUploadingImage)
                              const CircularProgressIndicator()
                            else ...[
                              Icon(
                                Icons.image,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AppLocalizations.of(context).t('tapToUpload'),
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ],
                        ),
                      ),
              ),
              if (_imageUrl != null && _imageUrl!.isNotEmpty) ...[
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: _handleImageUpload,
                  icon: const Icon(Icons.refresh),
                  label: Text(AppLocalizations.of(context).t('changeImage')),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).t('cancel')),
          ),
          ElevatedButton(
            onPressed: _isUploadingImage ? null : _save,
            child: Text(AppLocalizations.of(context).t('save')),
          ),
        ],
      );
    }

    return AlertDialog(
      title: Text(
        '${AppLocalizations.of(context).t('edit')} ${widget.field == 'name' ? AppLocalizations.of(context).t('name') : AppLocalizations.of(context).t('phoneNumber')}',
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: widget.field == 'name'
                ? AppLocalizations.of(context).t('fullName')
                : AppLocalizations.of(context).t('phoneNumber'),
            hintText: widget.field == 'name'
                ? AppLocalizations.of(context).t('enterYourName')
                : AppLocalizations.of(context).t('enterPhoneNumber'),
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            if (widget.field == 'name' && (value == null || value.isEmpty)) {
              return AppLocalizations.of(context).t('enterYourName');
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context).t('cancel')),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(AppLocalizations.of(context).t('save')),
        ),
      ],
    );
  }
}
