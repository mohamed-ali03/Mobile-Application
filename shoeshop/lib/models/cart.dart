import 'package:flutter/material.dart';
import 'package:shoeshop/models/shoe_model.dart';

class Cart extends ChangeNotifier {
  // shop shoes
  List<ShoeModel> shoeList = [
    ShoeModel(
      shoeName: "Nike Court Vision Low",
      shoePrice: "85", // Approximate retail price
      shoeImage: "assets/images/shoes-3.jpeg",
      sheoDescribtion:
          "A classic, '80s basketball-inspired low-top sneaker featuring a black and white synthetic leather upper. Known for its retro style and plush, low-cut collar.",
    ),
    ShoeModel(
      shoeName: "Nike Air Max 270",
      shoePrice: "170", // Approximate retail price
      shoeImage: "assets/images/shoes-2.jpeg",
      sheoDescribtion:
          "A lifestyle sneaker known for its large, visible Air unit in the heel (in a light blue/clear shade in this colorway). It features a white/light grey mesh upper for a modern, breathable fit.",
    ),
    ShoeModel(
      shoeName: "Nike Dunk Low",
      shoePrice:
          "120", // Approximate retail price for standard retro models (resale for some colorways can be much higher)
      shoeImage: "assets/images/shoes-1.jpeg",
      sheoDescribtion:
          "A low-profile basketball-turned-lifestyle icon. This colorway features a sail/off-white leather upper with pine green accents on the Swoosh, heel, and outsole.",
    ),
    ShoeModel(
      shoeName: "Nike Air Max 90",
      shoePrice: "130", // Approximate retail price
      shoeImage: "assets/images/shoes-4.jpeg",
      sheoDescribtion:
          "An iconic running shoe known for its layered upper and visible Max Air cushioning unit (blue in this colorway). This model features a white, grey, and charcoal upper with bright blue accents.",
    ),
  ];

  // user cart

  List<ShoeModel> userShoes = [];

  // get shoes list of the shop
  List<ShoeModel> getShoesList() {
    return shoeList;
  }

  // get shoes list of the user

  List<ShoeModel> getUserList() {
    return userShoes;
  }

  // add item to user cart

  void addItemToUserCart(ShoeModel shoe) {
    userShoes.add(shoe);
    notifyListeners();
  }

  // remove item from user cart

  void removeItemFromCart(ShoeModel shoe) {
    userShoes.remove(shoe);
    notifyListeners();
  }
}
