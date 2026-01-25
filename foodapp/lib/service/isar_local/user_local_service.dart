import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodapp/models/user%20model/user_model.dart';
import 'package:foodapp/service/isar_local/isar_service.dart';
import 'package:isar/isar.dart';

class UserLocalService {
  /// 💾 save or update user
  Future<void> saveUser(UserModel user) async {
    try {
      await IsarService.isar.writeTxn(() async {
        final existing = await getUserOnce();
        if (existing != null) {
          user.id = existing.id;
        }
        await IsarService.isar.userModels.put(user);
      });
    } catch (e) {
      debugPrint('Error saving user: $e');
      rethrow;
    }
  }

  /// 👀 watch user for real-time updates
  Stream<List<UserModel>> watchUsers() {
    try {
      return IsarService.isar.userModels.where().watch(fireImmediately: true);
    } catch (e) {
      debugPrint('Error watching user: $e');
      rethrow;
    }
  }

  /// 🔎 get user once from local DB
  Future<UserModel?> getUserOnce() async {
    try {
      return await IsarService.isar.userModels.where().findFirst();
    } catch (e) {
      debugPrint('Error getting user: $e');
      return null;
    }
  }

  /// ✏️ update current user profile
  Future<void> updateUser(
    String userId, {
    String? name,
    String? phoneNumber,
    int? buyingPoints,
    String? imageUrl,
    String? role,
    bool? blocked,
  }) async {
    try {
      await IsarService.isar.writeTxn(() async {
        final user = await IsarService.isar.userModels
            .filter()
            .authIDEqualTo(userId)
            .findFirst();
        if (user == null) {
          debugPrint('No user found to update');
          return;
        }

        if (name != null) user.name = name;
        if (phoneNumber != null) user.phoneNumber = phoneNumber;
        if (imageUrl != null) user.imageUrl = imageUrl;
        if (buyingPoints != null) user.buyingPoints = buyingPoints;
        if (role != null) user.role = role;
        if (blocked != null) user.blocked = blocked;
        await IsarService.isar.userModels.put(user);
      });
    } catch (e) {
      debugPrint('Error updating user: $e');
      rethrow;
    }
  }

  /// 📥 upsert multiple users (for syncing)
  Future<void> upsertUsers(List<UserModel> users) async {
    try {
      await IsarService.isar.writeTxn(() async {
        for (final user in users) {
          final existing = await IsarService.isar.userModels
              .filter()
              .authIDEqualTo(user.authID)
              .findFirst();

          if (existing != null) {
            user.id = existing.id;
          }

          await IsarService.isar.userModels.put(user);
        }
      });
    } catch (e) {
      debugPrint('Error upserting users: $e');
      rethrow;
    }
  }

  /// 📥 fetch all users except current
  Future<List<UserModel>> fetchUsersSkipFirst() async {
    try {
      final users = await IsarService.isar.userModels
          .where()
          .sortByCreatedAt()
          .findAll();

      if (users.length <= 1) return [];

      return users.sublist(1);
    } catch (e) {
      debugPrint('Error fetching users: $e');
      rethrow;
    }
  }

  /// 🗑️ clear all users from local DB
  Future<void> clear() async {
    try {
      await IsarService.isar.writeTxn(() async {
        await IsarService.isar.userModels.clear();
      });
    } catch (e) {
      debugPrint('Error clearing users: $e');
      rethrow;
    }
  }
}
