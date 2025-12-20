import 'package:flutter/cupertino.dart';
import 'package:foodapp/models/user%20model/user_model.dart';
import 'package:foodapp/service/isar_local/user_local_service.dart';
import 'package:foodapp/service/supabase_remote/auth_remote_service.dart';

class AuthRepository {
  final _remote = AuthRemoteService();
  final _local = UserLocalService();

  /// 🔑 login and sync profile to local DB (offline-safe)
  Future<void> login(String email, String password) async {
    try {
      final user = await _remote
          .login(email, password)
          .timeout(const Duration(seconds: 5));

      final profile = await _remote
          .fetchProfile(user.id)
          .timeout(const Duration(seconds: 5));

      final localUser = UserModel()
        ..authID = user.id
        ..name = profile['name']
        ..role = profile['role']
        ..phoneNumber = profile['phone_number']
        ..imageUrl = profile['image_url']
        ..createdAt = DateTime.parse(profile['created_at']);

      await _local.saveUser(localUser);
    } catch (e) {
      debugPrint('Failed to login or fetch profile: $e');
    }
  }

  /// 📝 register user and save locally
  Future<void> register({
    required String name,
    required String email,
    required String password,
    String role = 'user',
    String? phoneNumber,
    String? imageUrl,
  }) async {
    try {
      final user = await _remote
          .register(
            name: name,
            email: email,
            password: password,
            role: role,
            phoneNumber: phoneNumber,
            imagUrl: imageUrl,
          )
          .timeout(const Duration(seconds: 5));

      final localUser = UserModel()
        ..authID = user.id
        ..name = name
        ..role = role
        ..phoneNumber = phoneNumber
        ..imageUrl = imageUrl
        ..createdAt = DateTime.parse('created_at');

      await _local.saveUser(localUser);
    } catch (e) {
      debugPrint('Failed to register user remotely: $e');
    }
  }

  /// 🚪 logout
  Future<void> logout() async {
    try {
      await _remote.logout().timeout(const Duration(seconds: 5));
      await _local.clear();
    } catch (e) {
      debugPrint('Failed to logout remotely: $e');
    }
  }

  /// 👀 watch local user for UI updates
  Stream<UserModel?> watchUser() => _local.watchUser();

  /// 🔎 get user once
  Future<UserModel?> getUser() async {
    return await _local.getUserOnce();
  }
}
