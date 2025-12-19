import 'package:restaurant/feature/local_database/product%20item/product_item_entity.dart';
import 'package:restaurant/feature/models/product_item.dart';

extension ProductItemMapper on ProductItem {
  ProductItemEntity toEntity() {
    return ProductItemEntity()
      ..itemId = itemId
      ..itemName = itemName
      ..categoryId = categoryId
      ..categoryName = categoryName
      ..description = description
      ..ingredients = ingredients
      ..price = price
      ..rating = rating
      ..numOfReviews = numOfReviews
      ..imageUrl = imageUrl
      ..isAvailable = isAvailable;
  }
}

extension ProductItemEntityMapper on ProductItemEntity {
  ProductItem toDomain() {
    return ProductItem(
      itemId: itemId,
      itemName: itemName,
      categoryId: categoryId,
      categoryName: categoryName,
      description: description,
      ingredients: ingredients,
      price: price,
      rating: rating,
      numOfReviews: numOfReviews,
      imageUrl: imageUrl,
      isAvailable: isAvailable,
    );
  }
}
