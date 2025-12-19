import 'package:isar/isar.dart';

part 'user_model.g.dart';

@collection
class UserModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String authID;
  late String name;
  late String role;
  late String? phoneNumber;
  late String? imageUrl;
  late DateTime createdAt;
}
