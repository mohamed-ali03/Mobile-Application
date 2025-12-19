import 'package:isar/isar.dart';

part 'product_item_entity.g.dart';

@collection
class ProductItemEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String itemId;

  late String itemName;
  @Index()
  late String categoryId;
  late String categoryName;
  late String description;
  late String ingredients;
  late double price;
  double? rating;
  int? numOfReviews;
  late String imageUrl;
  late bool isAvailable;
}
