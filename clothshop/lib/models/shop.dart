import 'package:clothshop/models/product.dart';
import 'package:flutter/material.dart';

class Shop extends ChangeNotifier {
  // list of the products in the shop
  final List<Product> _shopProducts = [
    Product(
      name: "Grey Raglan Hoodie",
      price: 55.00,
      description:
          "Grey hoodie featuring raglan sleeves, a contrasting dark blue hood lining, a front kangaroo pocket, and adjustable drawstrings.",
      imagePath: "assets/images/cloth-1.jpg",
    ),
    Product(
      name: "Polo Shirt",
      price: 29.99,
      description:
          "Short-sleeved polo in a vibrant green, featuring a classic collar, two-button placket, and small chest embroidery.",
      imagePath: "assets/images/cloth-2.jpg",
    ),
    Product(
      name: "Light Blue Graphic Hoodie",
      price: 45.50,
      description:
          "Pale blue pullover hoodie with a drawstring hood, kangaroo pocket, and central \"Originals Studio\" text graphic.",
      imagePath: "assets/images/cloth-3.jpg",
    ),
    Product(
      name: "Dusty Rose Pullover Hoodie",
      price: 49.99,
      description:
          "Solid color, dusty rose pink pullover hoodie with long sleeves, a front pouch pocket, and black adjustable drawstrings.",
      imagePath: "assets/images/cloth-4.jpg",
    ),
  ];
  // list of the user products
  final List<Product> _userProducts = [];

  List<Product> getShopProducts() {
    return _shopProducts;
  }

  List<Product> getUserProducts() {
    return _userProducts;
  }

  void addToUserProducts(Product product) {
    _userProducts.add(product);
    notifyListeners();
  }

  void removeToUserProducts(Product product) {
    _userProducts.remove(product);
    notifyListeners();
  }
}
