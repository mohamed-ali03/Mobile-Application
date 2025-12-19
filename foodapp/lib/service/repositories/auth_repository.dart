import 'package:foodapp/models/user%20model/user_model.dart';
import 'package:foodapp/service/isar_local/user_local_service.dart';
import 'package:foodapp/service/supabase_remote/auth_remote_service.dart';

class AuthRepository {
  final _remote = AuthRemoteService();
  final _local = UserLocalService();

  // login and sync progile to isar
  Future<void> login(String email, String password) async {
    final user = await _remote.login(email, password);
    final profile = await _remote.fetchProfile(user.id);

    final localUser = UserModel()
      ..authID = user.id
      ..name = profile['name']
      ..role = profile['role']
      ..phoneNumber = profile['phone_number']
      ..imageUrl = profile['image_url']
      ..createdAt = DateTime.now();

    await _local.saveUser(localUser);
  }

  // register user and save locally
  Future<void> resgister({
    required String name,
    required String email,
    required String password,
    String role = 'user',
    String? phoneNumber,
    String? imageUrl,
  }) async {
    final user = await _remote.register(
      name: name,
      email: email,
      password: password,
      role: role,
      phoneNumber: phoneNumber,
      imagUrl: imageUrl,
    );

    final localUser = UserModel()
      ..authID = user.id
      ..name = name
      ..role = role
      ..phoneNumber = phoneNumber
      ..imageUrl = imageUrl
      ..createdAt = DateTime.now();

    await _local.saveUser(localUser);
  }

  // logout
  Future<void> logout() async {
    await _remote.logout();
    await _local.clear();
  }

  /// watch local user for UI updates
  Stream<UserModel?> watchUser() => _local.watchUser();

  // get user
  Future<UserModel?> getUser() async {
    return await _local.getUserOnce();
  }
}
