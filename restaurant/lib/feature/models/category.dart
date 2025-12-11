import 'package:restaurant/feature/models/product_item.dart';

class Category {
  String? categoryId;
  String? categoryName;
  String? imageUrl;
  List<ProductItem>? items;

  Category({this.categoryId, this.categoryName, this.imageUrl, this.items});

  Map<String, dynamic> toMap() => {
    'categoryId': categoryId,
    'categoryName': categoryName,
    'imageUrl': imageUrl,
  };

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      imageUrl: json['imageUrl'],
    );
  }
}
