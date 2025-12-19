import 'package:isar/isar.dart';

part 'user_entity.g.dart';

@collection
class UserEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String? uid;

  String? name;
  String? email;
  String? phoneNumber;
  String? location;
  String? imageUrl;
  String? providerId;
  String? role;
}
