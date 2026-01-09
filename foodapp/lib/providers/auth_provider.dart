import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodapp/models/user%20model/user_model.dart';
import 'package:foodapp/service/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final _repo = AuthRepository();

  UserModel? user;
  List<UserModel> users = [];
  bool isLoading = true;
  String? error;
  bool _isDisposed = false;

  AuthProvider() {
    _init();
  }

  /// Initialize provider and get current user
  Future<void> _init() async {
    try {
      user = await _repo.getCurrentUser();
      _setLoading(false);
    } catch (e) {
      _setError('Failed to initialize: $e');
      debugPrint('AuthProvider init error: $e');
      _setLoading(false);
    }
  }

  /// 🔑 Login with email and password
  Future<void> login(String email, String password) async {
    try {
      _setError(null);
      _setLoading(true);
      await _repo.login(email, password);
      user = await _repo.getCurrentUser();
      _setLoading(false);
    } catch (e) {
      _setError('Login failed: $e');
      debugPrint('Login error: $e');
      _setLoading(false);
    }
  }

  /// 📝 Register new user
  Future<void> register({
    required String name,
    required String email,
    required String password,
    String role = 'user',
    String? phoneNumber,
    String? imageUrl,
  }) async {
    try {
      _setError(null);
      _setLoading(true);
      await _repo.register(
        name: name,
        email: email,
        password: password,
        role: role,
        phoneNumber: phoneNumber,
        imageUrl: imageUrl,
      );
      user = await _repo.getCurrentUser();
      _setLoading(false);
    } catch (e) {
      _setError('Registration failed: $e');
      debugPrint('Register error: $e');
      _setLoading(false);
      rethrow;
    }
  }

  /// 🚪 Logout user
  Future<void> logout() async {
    try {
      _setError(null);
      _setLoading(true);
      await _repo.logout();
      user = null;
      users = [];
      _setLoading(false);
    } catch (e) {
      _setError('Logout failed: $e');
      debugPrint('Logout error: $e');
      _setLoading(false);
    }
  }

  /// ✏️ Update user profile
  Future<void> updateProfile({
    String? name,
    String? phoneNumber,
    String? imageUrl,
  }) async {
    try {
      _setError(null);
      _setLoading(true);
      if (user == null) {
        _setError('No user logged in');
        return;
      }

      await _repo.updateProfile(
        user!.authID,
        name: name,
        phoneNumber: phoneNumber,
        imageUrl: imageUrl,
      );
      user = await _repo.getCurrentUser();
      _setLoading(false);
    } catch (e) {
      _setError('Update failed: $e');
      debugPrint('Update profile error: $e');
      _setLoading(false);
    }
  }

  /// 🔄 Sync all profiles from remote
  Future<void> syncProfiles() async {
    try {
      _setError(null);
      _setLoading(true);
      await _repo.syncProfiles();
      _setLoading(false);
    } catch (e) {
      _setError('Sync failed: $e');
      debugPrint('Sync profiles error: $e');
      _setLoading(false);
    }
  }

  /// 📥 Fetch all users except current
  Future<void> fetchAllUsers() async {
    try {
      _setError(null);
      _setLoading(true);
      final fetched = await _repo.fetchAllUsers();
      // Exclude current user from the list
      users = fetched.where((u) => u.authID != user?.authID).toList();
      _setLoading(false);
    } catch (e) {
      _setError('Failed to fetch users: $e');
      debugPrint('Fetch all users error: $e');
      _setLoading(false);
    }
  }

  /// Change another user's role (admin only)
  Future<void> changeUserRole(String userAuthId, String newRole) async {
    try {
      _setError(null);
      _setLoading(true);
      await _repo.updateUserRole(userAuthId, newRole);
      // Refresh the local users list
      users = await _repo.fetchAllUsers();
      _setLoading(false);
    } catch (e) {
      _setError('Failed to change user role: $e');
      debugPrint('Change user role error: $e');
      _setLoading(false);
      rethrow;
    }
  }

  /// 🔧 Helper to safely set loading state
  void _setLoading(bool value) {
    if (!_isDisposed) {
      isLoading = value;
      notifyListeners();
    }
  }

  /// 🔧 Helper to safely set error state
  void _setError(String? value) {
    if (!_isDisposed) {
      error = value;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
