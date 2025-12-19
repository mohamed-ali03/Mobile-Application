import 'package:restaurant/feature/local_database/category/category_entity.dart';
import 'package:restaurant/feature/models/category.dart';

extension CategoryMapper on Category {
  CategoryEntity toEntity() {
    return CategoryEntity()
      ..categoryId = categoryId
      ..categoryName = categoryName
      ..imageUrl = imageUrl;
  }
}

extension CategoryEntityMapper on CategoryEntity {
  Category toDomain() {
    return Category(
      categoryId: categoryId,
      categoryName: categoryName,
      imageUrl: imageUrl,
    );
  }
}
