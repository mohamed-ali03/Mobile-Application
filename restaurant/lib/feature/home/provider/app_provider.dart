import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant/core/constants.dart';
import 'package:restaurant/feature/home/firestore/firestore.dart';
import 'package:restaurant/feature/home/firestore/supabase_storage.dart';
import 'package:restaurant/feature/models/category.dart';
import 'package:restaurant/feature/models/modification.dart';
import 'package:restaurant/feature/models/order_model.dart';
import 'package:restaurant/feature/models/product_item.dart';
import 'package:restaurant/feature/models/user.dart';

class AppProvider extends ChangeNotifier {
  Modification modification = Modification(
    userVersion: 0,
    menuVersion: 0,
    cartVersion: 0,
  );
  List<Category> categories = [];
  List<UserModel> users = [];
  List<OrderModel> orders = [];
  String imageURL = '';

  // Call this once, for example in the provider's init or main page init
  void listenToAppStatus() {
    Firestore.watchAppStatus().listen((updatedModification) {
      supportedFunction(updatedModification);
    });
  }

  // check which collection is modified
  void supportedFunction(Modification updatedModification) {
    if (modification.userVersion != updatedModification.userVersion) {
      getUsers();
    } else if (modification.menuVersion != updatedModification.menuVersion) {
      getMenu();
    } else if (modification.cartVersion != updatedModification.cartVersion) {}
    modification = updatedModification;
    imageURL = '';
  }

  // check if there is any update
  Future<RequestStatus> checkAppStatus() async {
    try {
      Modification temp = await Firestore.getAppStatus();
      supportedFunction(temp);
      return RequestStatus.success;
    } catch (e) {
      return RequestStatus.error;
    }
  }

  // ================================
  // GET MENU
  // ================================
  Future<RequestStatus> getMenu() async {
    try {
      categories = await Firestore.getMenu();
      notifyListeners();
      return RequestStatus.success;
    } catch (e) {
      return RequestStatus.error;
    }
  }

  /*
      User
  */

  // ================================
  // GET USERS
  // ================================
  Future<RequestStatus> getUsers() async {
    try {
      await Firestore.getUsers();
      notifyListeners();
      return RequestStatus.success;
    } catch (e) {
      return RequestStatus.error;
    }
  }

  // ================================
  // GET USER BY ID
  // ================================
  Future<UserModel?> getUserByID(String userID) async {
    try {
      if (userID.isNotEmpty) {
        return await Firestore.getUser(userID);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ================================
  // ADD USER
  // ================================
  Future<RequestStatus> addUser(UserModel user) async {
    try {
      await Firestore.addUserIfNotExists(user);
      Modification temp = Modification.fromJson(modification.toMap());
      temp.userVersion++;
      await Firestore.modifiyAppStatus(temp);
      return RequestStatus.success;
    } catch (e) {
      return RequestStatus.error;
    }
  }

  /*
        CATEGORY
  */

  // ================================
  // GET CATEGORY BY ID
  // ================================
  Future<Category?> getCategory(String categoryID) async {
    try {
      if (categoryID.isNotEmpty) {
        Category category = await Firestore.getCategory(categoryID);
        return category;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ================================
  // ADD CATEGORY
  // ================================
  Future<RequestStatus> addCategory(
    String categoryName,
    String imageURL,
  ) async {
    try {
      if (categoryName.isNotEmpty && imageURL.isNotEmpty) {
        await Firestore.addNewCategry(categoryName, imageURL);
        Modification temp = Modification.fromJson(modification.toMap());
        temp.menuVersion++;
        await Firestore.modifiyAppStatus(temp);
        return RequestStatus.success;
      }
      return RequestStatus.empty;
    } catch (e) {
      return RequestStatus.error;
    }
  }

  // ================================
  // MODIFY CATEGORY
  // ================================
  Future<RequestStatus> modifyCategory(
    Category category, [
    String? categoryName,
    String? imageURL,
  ]) async {
    try {
      if ((categoryName?.isNotEmpty ?? false) ||
          (imageURL?.isNotEmpty ?? false)) {
        await Firestore.modifyCategry(category, categoryName, imageURL);
        Modification temp = Modification.fromJson(modification.toMap());
        temp.menuVersion++;
        await Firestore.modifiyAppStatus(temp);
        return RequestStatus.success;
      }
      return RequestStatus.empty;
    } catch (e) {
      return RequestStatus.error;
    }
  }

  // ================================
  // DELETE CATEGORY (with recursive delete)
  // ================================
  Future<RequestStatus> deleteCategory(String categoryID) async {
    try {
      await Firestore.deleteCategory(categoryID);
      Modification temp = Modification.fromJson(modification.toMap());
      temp.menuVersion++;
      await Firestore.modifiyAppStatus(temp);
      return RequestStatus.success;
    } catch (e) {
      return RequestStatus.error;
    }
  }

  /*  
      ITEM
  */

  // ================================
  // GET ITEM BY ID
  // ================================
  Future<RequestStatus> getItem(String itemID, String categoryId) async {
    try {
      if (categoryId.isNotEmpty && itemID.isNotEmpty) {
        await Firestore.getItem(itemID, categoryId);
        return RequestStatus.success;
      }
      return RequestStatus.empty;
    } catch (e) {
      return RequestStatus.error;
    }
  }

  // ================================
  // ADD ITEM
  // ================================
  Future<RequestStatus> addNewItem(ProductItem item) async {
    try {
      if (item.categoryId.isNotEmpty &&
          item.itemName.isNotEmpty &&
          item.itemName.isNotEmpty &&
          item.ingredients.isNotEmpty &&
          item.description.isNotEmpty &&
          item.imageUrl.isNotEmpty &&
          item.categoryName.isNotEmpty) {
        await Firestore.addNewItem(item);
        Modification temp = Modification.fromJson(modification.toMap());
        temp.menuVersion++;
        await Firestore.modifiyAppStatus(temp);
        return RequestStatus.success;
      }
      return RequestStatus.empty;
    } catch (e) {
      return RequestStatus.error;
    }
  }

  Future<RequestStatus> modifyItem(
    ProductItem product, {
    String? newName,
    String? newCategoryId,
    String? newCategoryName,
    String? newDescription,
    String? newIngredients,
    double? newPrice,
    double? newRating,
    String? newImageUrl,
    bool? newAvailability,
  }) async {
    try {
      // Check if itemId exists and at least one parameter is not null
      if (product.itemId.isNotEmpty &&
          (newName != null ||
              newCategoryId != null ||
              newCategoryName != null ||
              newDescription != null ||
              newIngredients != null ||
              newPrice != null ||
              newRating != null ||
              newImageUrl != null ||
              newAvailability != null)) {
        // Call Firestore method
        await Firestore.modifyItem(
          product,
          newName: newName,
          newCategoryId: newCategoryId,
          newCategoryName: newCategoryName,
          newDescription: newDescription,
          newIngredients: newIngredients,
          newPrice: newPrice,
          newRating: newRating,
          newImageUrl: newImageUrl,
          newAvailability: newAvailability,
        );
        Modification temp = Modification.fromJson(modification.toMap());
        temp.menuVersion++;
        await Firestore.modifiyAppStatus(temp);
        return RequestStatus.success;
      }

      return RequestStatus.empty;
    } catch (e) {
      return RequestStatus.error;
    }
  }

  // ================================
  // DELETE ITEM
  // ================================
  Future<RequestStatus> deleteItem(
    String categoryID,
    String itemID,
    String imageUrl,
  ) async {
    try {
      final filename = imageUrl.split('/').last;
      await SupabaseStorage.deleteImage('items', filename);
      await Firestore.deleteItem(categoryID, itemID);
      Modification temp = Modification.fromJson(modification.toMap());
      temp.menuVersion++;
      await Firestore.modifiyAppStatus(temp);
      return RequestStatus.success;
    } catch (e) {
      return RequestStatus.error;
    }
  }

  /*
      SUPABASE STORAGE
  */

  // ================================
  // UPLOAD IMAGE
  // ================================
  Future<RequestStatus> uploadImage(
    String bucket,
    String filename,
    File file,
  ) async {
    try {
      if (bucket.isNotEmpty && filename.isNotEmpty && file.existsSync()) {
        final url = await SupabaseStorage.uploadImage(bucket, filename, file);
        if (url != null && url.isNotEmpty) {
          imageURL = url;
          notifyListeners();
          return RequestStatus.success;
        }
        return RequestStatus.error;
      }
      return RequestStatus.empty;
    } catch (e) {
      return RequestStatus.error;
    }
  }

  // ================================
  // DELETE IMAGE
  // ================================
  Future<RequestStatus> deleteImage(String bucket, String filename) async {
    try {
      if (bucket.isNotEmpty && filename.isNotEmpty) {
        await SupabaseStorage.deleteImage(bucket, filename);
        return RequestStatus.success;
      }
      return RequestStatus.empty;
    } catch (e) {
      return RequestStatus.error;
    }
  }
}
