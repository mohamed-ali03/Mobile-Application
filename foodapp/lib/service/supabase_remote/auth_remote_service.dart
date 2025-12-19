import 'package:foodapp/service/supabase_remote/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteService {
  // login with password
  Future<User> login(String email, String password) async {
    final res = await SupabaseService.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return res.user!;
  }

  // register with password
  Future<User> register({
    required String email,
    required String password,
    required String name,
    String role = 'user',
    String? phoneNumber,
    String? imagUrl,
  }) async {
    final res = await SupabaseService.client.auth.signUp(
      email: email,
      password: password,
    );
    final user = res.user!;

    // Insert profile in supabase
    await SupabaseService.client.from('profiles').insert({
      'id': user.id,
      'name': name,
      'role': role,
      'phone_number': phoneNumber,
      'image_url': imagUrl,
    });
    return user;
  }

  // fetch profile data
  Future<Map<String, dynamic>> fetchProfile(String userId) async {
    return await SupabaseService.client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
  }

  // log out
  Future<void> logout() async {
    await SupabaseService.client.auth.signOut();
  }
}
