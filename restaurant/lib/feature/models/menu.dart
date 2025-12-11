import 'package:restaurant/feature/models/category.dart';

class Menu {
  final String? menuId;
  final List<Category>? categories;

  Menu({this.menuId, this.categories});

  Map<String, dynamic> toMap() => {'menuID': menuId, 'categories': categories};

  factory Menu.fromJson(Map<String, dynamic>? json) => Menu(
    menuId: json!['menuID'],
    categories: json['categories'] != null
        ? List<Category>.from(json['categories'])
        : [],
  );
}
