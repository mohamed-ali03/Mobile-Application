import 'package:flutter/material.dart';
import 'package:foodapp/l10n/app_localizations.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final authState = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // header with avatar placeholder
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(
                          context,
                        ).t('wlecomeCreateYourAccount'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 18),

                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).t('fullName'),
                          prefixIcon: const Icon(Icons.person),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return AppLocalizations.of(
                              context,
                            ).t('nameIsRequired');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).t('email'),
                          prefixIcon: const Icon(Icons.email),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return AppLocalizations.of(
                              context,
                            ).t('emailRequired');
                          }
                          final email = v.trim();
                          final regex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");
                          if (!regex.hasMatch(email)) {
                            return AppLocalizations.of(context).t('validEmail');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).t('password'),
                          prefixIcon: const Icon(Icons.lock),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return AppLocalizations.of(
                              context,
                            ).t('passwordRequired');
                          }
                          if (v.trim().length < 6) {
                            return AppLocalizations.of(
                              context,
                            ).t('passwordMinLengthRegister');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(
                            context,
                          ).t('phoneNumber'),
                          prefixIcon: const Icon(Icons.phone),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppLocalizations.of(
                              context,
                            ).t('phoneRequired');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),

                      SizedBox(
                        width: double.infinity,
                        child: authState.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () async {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }

                                  try {
                                    await auth.register(
                                      name: nameController.text.trim(),
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                      phoneNumber: phoneController.text.trim(),
                                    );

                                    if (!context.mounted) return;

                                    if (auth.error != null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text(auth.error!)),
                                      );
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  } catch (e) {
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  }
                                },
                                child: Text(
                                  AppLocalizations.of(
                                    context,
                                  ).t('createAccount'),
                                ),
                              ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(
                              context,
                            ).t('alreadyHaveAccount'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              AppLocalizations.of(context).t('signIn'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
