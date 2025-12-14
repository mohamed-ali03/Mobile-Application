class ProductItem {
  String itemId;
  String itemName;
  String categoryId;
  String categoryName;
  String description;
  String ingredients;
  double price;
  double? rating;
  int? numOfReviews;
  String imageUrl;
  bool isAvailable;

  ProductItem({
    required this.itemId,
    required this.itemName,
    required this.categoryId,
    required this.categoryName,
    required this.description,
    required this.ingredients,
    required this.price,
    this.rating,
    this.numOfReviews,
    required this.isAvailable,
    required this.imageUrl,
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
    'numOfReviews': numOfReviews,
    'isAvailable': isAvailable,
    'imageUrl': imageUrl,
  };

  factory ProductItem.fromJson(Map<String, dynamic> json) => ProductItem(
    itemId: json['itemId'] ?? '',
    itemName: json['itemName'] ?? '',
    categoryId: json['categoryId'] ?? '',
    categoryName: json['categoryName'] ?? '',
    description: json['description'] ?? '',
    ingredients: json['ingredients'] ?? '',
    price: (json['price'] is int)
        ? (json['price'] as int).toDouble()
        : (json['price'] ?? 0.0),
    rating: (json['rating'] is int)
        ? (json['rating'] as int).toDouble()
        : (json['rating'] ?? 0.0),
    numOfReviews: (json['numOfReviews'] is double)
        ? (json['numOfReviews'] as double).toInt()
        : (json['numOfReviews'] ?? 0),
    isAvailable: json['isAvailable'] ?? true,
    imageUrl: json['imageUrl'] ?? '',
  );
}
