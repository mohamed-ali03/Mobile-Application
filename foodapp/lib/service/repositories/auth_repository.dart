import 'package:flutter/cupertino.dart';
import 'package:foodapp/models/user%20model/user_model.dart';
import 'package:foodapp/service/isar_local/user_local_service.dart';
import 'package:foodapp/service/supabase_remote/auth_remote_service.dart';

class AuthRepository {
  final _remote = AuthRemoteService();
  final _local = UserLocalService();

  static const _timeout = Duration(seconds: 10);

  /// 🔑 login and sync profile to local DB (offline-safe)
  Future<bool> login(String email, String password) async {
    try {
      final user = await _remote.login(email, password).timeout(_timeout);

      final profile = await _remote.fetchProfile(user.id).timeout(_timeout);

      final localUser = UserModel()
        ..authID = user.id
        ..name = profile['name'] ?? ''
        ..role = profile['role'] ?? 'user'
        ..phoneNumber = profile['phone_number']
        ..imageUrl = profile['image_url']
        ..buyingPoints = profile['buying_points']
        ..blocked = profile['blocked']
        ..createdAt = _parseDate(profile['created_at']);

      await _local.saveUser(localUser);

      return localUser.role == 'user';
    } catch (e) {
      debugPrint('Failed to login or fetch profile: $e');
      rethrow;
    }
  }

  /// 📝 register user and save locally
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    String role = 'user',
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
            imageUrl: imageUrl,
          )
          .timeout(_timeout);

      final localUser = UserModel()
        ..authID = user.id
        ..name = name
        ..role = role
        ..phoneNumber = phoneNumber
        ..createdAt = _parseDate(user.createdAt)
        ..imageUrl = imageUrl;

      await _local.saveUser(localUser);
    } catch (e) {
      debugPrint('Failed to register user: $e');
      rethrow;
    }
  }

  /// 🚪 logout and clear local data
  Future<void> logout() async {
    try {
      await _remote.logout().timeout(_timeout);
      await _local.clear();
    } catch (e) {
      debugPrint('Failed to logout remotely: $e');
      rethrow;
    }
  }

  /// ✏️ update user profile
  Future<void> updateProfile(
    String userId, {
    String? name,
    String? role,
    String? phoneNumber,
    int? buyingPoints,
    String? imageUrl,
    bool? blocked,
  }) async {
    try {
      await _remote
          .updateProfile(
            userId,
            name: name,
            role: role,
            phoneNumber: phoneNumber,
            imageUrl: imageUrl,
            buyingPoints: buyingPoints,
            blocked: blocked,
          )
          .timeout(_timeout);

      // Update local cache
      try {
        await _local.updateUser(
          userId,
          name: name,
          phoneNumber: phoneNumber,
          imageUrl: imageUrl,
          buyingPoints: buyingPoints,
          blocked: blocked,
        );
      } catch (e) {
        debugPrint('Failed to update local cache: $e');
        // Don't rethrow - remote update succeeded
      }
    } catch (e) {
      debugPrint('Failed to update profile remotely: $e');
      rethrow;
    }
  }

  /// 👤 get current authenticated user
  Future<UserModel?> getCurrentUser() async {
    try {
      return await _local.getUserOnce();
    } catch (e) {
      debugPrint('Failed to get current user: $e');
      return null;
    }
  }

  /// 🔐 check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final user = await _local.getUserOnce();
      return user != null;
    } catch (e) {
      debugPrint('Failed to check authentication: $e');
      return false;
    }
  }

  /// 👀 watch local user for UI updates
  Stream<List<UserModel>> watchUsers() {
    try {
      return _local.watchUsers();
    } catch (e) {
      debugPrint('Failed to watch user: $e');
      rethrow;
    }
  }

  /// 🔄 sync all profiles with remote database
  Future<void> syncProfiles() async {
    try {
      final profiles = await _remote.fetchAllProfiles().timeout(_timeout);

      final users = profiles.map<UserModel>((profile) {
        return UserModel()
          ..authID = profile['id']
          ..name = profile['name'] ?? ''
          ..role = profile['role'] ?? 'user'
          ..phoneNumber = profile['phone_number']
          ..imageUrl = profile['image_url']
          ..buyingPoints = profile['buying_points'] ?? 0
          ..blocked = profile['blocked']
          ..createdAt = _parseDate(profile['created_at']);
      }).toList();

      await _local.upsertUsers(users);
    } catch (e) {
      debugPrint('syncProfiles error: $e');
      rethrow;
    }
  }

  /// Update a user's role remotely and update local cache
  Future<void> updateUserRole(String userId, String role) async {
    try {
      await _remote.updateProfile(userId, role: role).timeout(_timeout);

      // Update local cache by fetching profile and updating single user
      try {
        final profile = await _remote.fetchProfile(userId).timeout(_timeout);
        final user = UserModel()
          ..authID = profile['id']
          ..name = profile['name'] ?? ''
          ..role = profile['role'] ?? 'user'
          ..phoneNumber = profile['phone_number']
          ..imageUrl = profile['image_url']
          ..buyingPoints = profile['buying_points'] ?? 0
          ..blocked = profile['blocked']
          ..createdAt = _parseDate(profile['created_at']);

        await _local.updateUser(
          userId,
          name: user.name,
          role: user.role,
          phoneNumber: user.phoneNumber,
          imageUrl: user.imageUrl,
          buyingPoints: user.buyingPoints,
          blocked: user.blocked,
        );
      } catch (e) {
        debugPrint('Failed to update local cache after role change: $e');
      }
    } catch (e) {
      debugPrint('Failed to update user role: $e');
      rethrow;
    }
  }

  /// 📥 fetch all users from local database
  Future<void> fetchAllUsers() async {
    try {
      // Try to fetch from remote first and update local cache
      try {
        final profiles = await _remote.fetchAllProfiles().timeout(_timeout);
        final users = profiles.map<UserModel>((profile) {
          return UserModel()
            ..authID = profile['id']
            ..name = profile['name'] ?? ''
            ..role = profile['role'] ?? 'user'
            ..phoneNumber = profile['phone_number']
            ..imageUrl = profile['image_url']
            ..buyingPoints = profile['buying_points']
            ..blocked = profile['blocked']
            ..createdAt = _parseDate(profile['created_at']);
        }).toList();

        await _local.upsertUsers(users);
      } catch (e) {
        // If remote fetch fails, fall back to local cache
        debugPrint('Failed to fetch remote profiles: $e');
      }
    } catch (e) {
      debugPrint('fetchAllUsers error: $e');
    }
  }

  /// 🔧 helper to safely parse dates
  DateTime? _parseDate(dynamic date) {
    if (date == null) return null;
    try {
      return DateTime.parse(date.toString());
    } catch (e) {
      debugPrint('Date parse error: $e');
      return null;
    }
  }
}
