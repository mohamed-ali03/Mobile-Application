import 'package:isar/isar.dart';

part 'item_model.g.dart';

@collection
class ItemModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late int itemId;
  @Index()
  late int categoryId;

  late String name;
  late String description;
  late double price;
  late String imageUrl;
  late String ingreidents;
  late bool available = false;
}
