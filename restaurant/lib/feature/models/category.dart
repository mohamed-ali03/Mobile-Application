import 'package:restaurant/feature/models/product_item.dart';

class Category {
  String categoryId;
  String categoryName;
  String imageUrl;
  List<ProductItem> items = [];

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() => {
    'categoryId': categoryId,
    'categoryName': categoryName,
    'imageUrl': imageUrl,
  };

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
