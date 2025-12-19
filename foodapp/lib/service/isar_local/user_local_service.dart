import 'package:foodapp/models/user%20model/user_model.dart';
import 'package:foodapp/service/isar_local/isar_service.dart';
import 'package:isar/isar.dart';

class UserLocalService {
  // save user
  Future<void> saveUser(UserModel user) async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.userModels.clear();
      await IsarService.isar.userModels.put(user);
    });
  }

  // watch user
  Stream<UserModel?> watchUser() {
    return IsarService.isar.userModels.where().watch().map(
      (list) => list.isEmpty ? null : list.first,
    );
  }

  // get user
  Future<UserModel?> getUserOnce() async {
    return await IsarService.isar.userModels.where().findFirst();
  }

  // clear user
  Future<void> clear() async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.userModels.clear();
    });
  }
}
