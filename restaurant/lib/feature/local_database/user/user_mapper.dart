import 'package:restaurant/feature/local_database/user/user_entity.dart';
import 'package:restaurant/feature/models/user.dart';

extension UserMapper on UserModel {
  UserEntity toEntity() {
    return UserEntity()
      ..name = name
      ..email = email
      ..phoneNumber = phoneNumber
      ..location = location
      ..uid = uid
      ..imageUrl = imageUrl
      ..providerId = providerId
      ..role = role;
  }
}

extension UserEntityMapper on UserEntity {
  UserModel toDomain() {
    return UserModel()
      ..name = name
      ..email = email
      ..phoneNumber = phoneNumber
      ..location = location
      ..uid = uid
      ..imageUrl = imageUrl
      ..providerId = providerId
      ..role = role;
  }
}
