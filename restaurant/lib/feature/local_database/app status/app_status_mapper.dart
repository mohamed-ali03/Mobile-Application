import 'package:restaurant/feature/local_database/app%20status/app_status_entity.dart';
import 'package:restaurant/feature/models/modification.dart';

extension AppStatusMapper on Modification {
  AppStatusEntity toEntity() {
    return AppStatusEntity()
      ..menuVersion = menuVersion
      ..userVersion = userVersion
      ..cartVersion = cartVersion;
  }
}

extension AppStatusEntityMapper on AppStatusEntity {
  Modification toDomain() {
    return Modification(
      userVersion: userVersion,
      menuVersion: menuVersion,
      cartVersion: cartVersion,
    );
  }
}
