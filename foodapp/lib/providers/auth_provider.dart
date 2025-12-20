import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodapp/models/user%20model/user_model.dart';
import 'package:foodapp/service/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final _repo = AuthRepository();

  UserModel? user;
  bool isLoading = true;

  late StreamSubscription<UserModel?> _sub;

  AuthProvider() {
    // get user at the begining and then listen to update
    _init();
  }

  Future<void> _init() async {
    // read once
    user = await _repo.getUser();

    //  stop loading immediately
    isLoading = false;
    notifyListeners();

    // listen to isar changes
    _sub = _repo.watchUser().listen((u) {
      user = u;
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) =>
      _repo.login(email, password);

  Future<void> register({
    required String name,
    required String email,
    required String password,
    String role = 'user',
    String? phoneNumber,
    String? imageUrl,
  }) => _repo.register(
    name: name,
    email: email,
    password: password,
    role: role,
    phoneNumber: phoneNumber,
    imageUrl: imageUrl,
  );

  Future<void> logout() => _repo.logout();

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
