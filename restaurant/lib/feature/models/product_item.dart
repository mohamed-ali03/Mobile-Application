class ProductItem {
  String? itemId;
  String itemName;
  String categoryId;
  String? categoryName;
  String? description;
  List<String>? ingredients;
  double? price;
  double? rating;
  String? imageUrl;
  bool? isAvailable;

  ProductItem({
    this.itemId,
    required this.itemName,
    required this.categoryId,
    this.categoryName,
    this.description,
    this.ingredients,
    this.price,
    this.rating,
    this.isAvailable,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() => {
    'itemId': itemId,
    'itemName': itemName,
    'categoryId': categoryId,
    'categoryName': categoryName,
    'description': description,
    'ingredients': ingredients,
    'price': price,
    'rating': rating,
    'isAvailable': isAvailable,
    'imageUrl': imageUrl,
  };

  factory ProductItem.fromJson(Map<String, dynamic> json) => ProductItem(
    itemId: json['itemId'] ?? '',
    itemName: json['itemName'] ?? '',
    categoryId: json['categoryId'] ?? '',
    categoryName: json['categoryName'] ?? '',
    description: json['description'] ?? '',
    ingredients: List<String>.from(json['ingredients'] ?? []),
    price: (json['price'] is int)
        ? (json['price'] as int).toDouble()
        : (json['price'] ?? 0.0),
    rating: (json['rating'] is int)
        ? (json['rating'] as int).toDouble()
        : (json['rating'] ?? 0.0),
    isAvailable: json['isAvailable'] ?? true,
    imageUrl: json['imageUrl'] ?? '',
  );
}
