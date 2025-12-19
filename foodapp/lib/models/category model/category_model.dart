import 'package:isar/isar.dart';

part 'category_model.g.dart';

@collection
class CategoryModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late int categoryId;
  late String name;
  late String imageUrl;
  late DateTime createdAt;
}
