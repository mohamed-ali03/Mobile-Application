import 'package:flutter/material.dart';
import 'package:foodapp/service/supabase_remote/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteService {
  /// Login with email and password
  Future<User> login(String email, String password) async {
    try {
      final res = await SupabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return res.user!;
    } catch (e) {
      debugPrint('Login error: $e');
      rethrow;
    }
  }

  /// Register with email, password, and profile data
  Future<User> register({
    required String email,
    required String password,
    required String name,
    String role = 'user',
    String? phoneNumber,
    String? imageUrl,
  }) async {
    try {
      // Sign up user
      final res = await SupabaseService.client.auth.signUp(
        email: email,
        password: password,
      );
      final user = res.user!;

      // Insert profile in database
      await SupabaseService.client.from('profiles').insert({
        'id': user.id,
        'name': name,
        'role': role,
        'phone_number': phoneNumber,
        'image_url': imageUrl,
      });

      return user;
    } catch (e) {
      debugPrint('Register error: $e');
      rethrow;
    }
  }

  /// Fetch single profile by user ID
  Future<Map<String, dynamic>> fetchProfile(String userId) async {
    try {
      return await SupabaseService.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
    } catch (e) {
      debugPrint('Fetch profile error: $e');
      rethrow;
    }
  }

  /// Fetch all profiles (admin only)
  Future<List<Map<String, dynamic>>> fetchAllProfiles() async {
    try {
      return await SupabaseService.client.from('profiles').select();
    } catch (e) {
      debugPrint('Fetch all profiles error: $e');
      rethrow;
    }
  }

  /// Update profile data
  Future<void> updateProfile(
    String userId, {
    String? name,
    String? phoneNumber,
    String? imageUrl,
  }) async {
    try {
      await SupabaseService.client
          .from('profiles')
          .update({
            if (name != null) 'name': name,
            if (phoneNumber != null) 'phone_number': phoneNumber,
            if (imageUrl != null) 'image_url': imageUrl,
          })
          .eq('id', userId);
    } catch (e) {
      debugPrint('Update profile error: $e');
      rethrow;
    }
  }

  /// Log out current user
  Future<void> logout() async {
    try {
      await SupabaseService.client.auth.signOut();
    } catch (e) {
      debugPrint('Logout error: $e');
      rethrow;
    }
  }

  /// Get current authenticated user
  User? getCurrentUser() {
    return SupabaseService.client.auth.currentUser;
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return SupabaseService.client.auth.currentUser != null;
  }
}
