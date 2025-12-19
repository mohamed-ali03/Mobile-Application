import 'package:isar/isar.dart';

part 'app_status_entity.g.dart';

@collection
class AppStatusEntity {
  Id id = Isar.autoIncrement;

  late int userVersion;
  late int menuVersion;
  late int cartVersion;
}
