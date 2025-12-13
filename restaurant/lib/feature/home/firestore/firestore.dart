import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant/feature/models/category.dart';
import 'package:restaurant/feature/models/menu.dart';
import 'package:restaurant/feature/models/order_model.dart';
import 'package:restaurant/feature/models/product_item.dart';
import 'package:restaurant/feature/models/user.dart';

class Firestore {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --------------------------------------------------USERS CRUD-------------------------------------------------------
  // ================================
  // GET USERS
  // ================================
  static Future<List<UserModel>> getUsers() async {
    try {
      final querySnapshot = await _firestore.collection('Users').get();

      if (querySnapshot.docs.isNotEmpty) {
        List<UserModel> users = querySnapshot.docs
            .map((user) => UserModel.fromJson(user.data()))
            .toList();

        return users;
      } else {
        throw Exception('No Users found');
      }
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  // ================================
  // GET USER BY ID
  // ================================
  static Future<UserModel> getUser(String userID) async {
    try {
      final doc = await _firestore.collection('Users').doc(userID).get();

      if (!doc.exists) {
        throw Exception('User not found');
      }
      UserModel user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
      return user;
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  // ================================
  // ADD USER
  // ================================
  static Future<void> addUserIfNotExists(UserModel user) async {
    try {
      final doc = await _firestore.collection('Users').doc(user.uid).get();

      if (!doc.exists) {
        await doc.reference.set(user.toMap());
      }
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  // ================================
  // MODIFY USER
  // ================================
  static Future<void> modifyUser(
    UserModel user, [
    String? newName,
    String? newRole,
    String? newPhoneNumber,
    String? newLocation,
    String? imageURL,
  ]) async {
    try {
      await _firestore.collection('Users').doc(user.uid).update({
        'name': newName ?? user.name,
        'role': newRole ?? user.role,
        'phoneNumber': newPhoneNumber ?? user.phoneNumber,
        'location': newLocation ?? user.location,
        'image': imageURL ?? user.imageUrl,
      });
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  // ================================
  // DELETE USER
  // ================================
  static Future<void> deleteUser(String userID) async {
    try {
      await _firestore.collection('Users').doc(userID).delete();
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  // ================================
  // GET MENU
  // ================================
  static Future<Menu> getMenu() async {
    try {
      // Step 1: Fetch all categories
      final categorySnapshot = await _firestore.collection('Menu').get();

      if (categorySnapshot.docs.isEmpty) {
        throw Exception('No menu found');
      }

      List<Category> categories = [];

      for (var doc in categorySnapshot.docs) {
        // Convert category
        Category category = Category.fromJson(doc.data());

        // Step 2: Fetch items under category
        final itemsSnapshot = await _firestore
            .collection('Menu')
            .doc(category.categoryId)
            .collection('items')
            .get();

        List<ProductItem> items = itemsSnapshot.docs
            .map((itemDoc) => ProductItem.fromJson(itemDoc.data()))
            .toList();

        category.items = items;

        // Add finished category to list
        categories.add(category);
      }

      return Menu(categories: categories);
    } on FirebaseException catch (e) {
      throw Exception("Firebase error: ${e.code}");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // --------------------------------------------------CATEGORY CRUD-------------------------------------------------------

  // ================================
  // GET CATEGORY BY ID
  // ================================
  static Future<Category> getCategory(String categoryID) async {
    try {
      final doc = await _firestore.collection('Menu').doc(categoryID).get();

      if (!doc.exists) {
        throw Exception('Category not found');
      }
      Category category = Category.fromJson(doc.data() as Map<String, dynamic>);
      return category;
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  // ================================
  // ADD CATEGORY
  // ================================
  static Future<void> addNewCategry(
    String categoryName, [
    String? imageURL,
  ]) async {
    try {
      final categoryRef = _firestore.collection('Menu').doc();

      Category category = Category(
        categoryId: categoryRef.id,
        categoryName: categoryName,
        imageUrl: imageURL,
      );

      await categoryRef.set(category.toMap());
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  // ================================
  // MODIFY CATEGORY
  // ================================
  static Future<void> modifyCategry(
    Category category, [
    String? newName,
    String? imageURL,
  ]) async {
    try {
      await _firestore.collection('Menu').doc(category.categoryId).update({
        'categoryName': newName ?? category.categoryName,
        'imageUrl': imageURL ?? category.imageUrl,
      });
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  // ================================
  // DELETE CATEGORY (with recursive delete)
  // ================================
  static Future<void> deleteCategory(String categoryID) async {
    try {
      final categoryRef = _firestore.collection('Menu').doc(categoryID);

      // 1. Get all items inside the category
      final itemsSnapshot = await categoryRef.collection('items').get();

      // 2. Delete each item document
      for (var doc in itemsSnapshot.docs) {
        await categoryRef.collection('items').doc(doc.id).delete();
      }

      // 3. Delete the category itself
      await categoryRef.delete();
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  // --------------------------------------------------ITEM CRUD-------------------------------------------------------

  // ================================
  // GET ITEM BY ID
  // ================================
  static Future<ProductItem> getItem(String itemID, String categoryId) async {
    try {
      final doc = await _firestore
          .collection('Menu')
          .doc(categoryId)
          .collection('items')
          .doc(itemID)
          .get();

      if (!doc.exists) {
        throw Exception('Item not found');
      }
      ProductItem productItem = ProductItem.fromJson(
        doc.data() as Map<String, dynamic>,
      );
      return productItem;
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  // ================================
  // ADD ITEM
  // ================================
  static Future<void> addNewItem(ProductItem product) async {
    try {
      final productRef = _firestore
          .collection('Menu')
          .doc(product.categoryId)
          .collection('items')
          .doc();

      product.itemId = productRef.id;

      await productRef.set(product.toMap());
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  // ================================
  // MODIFY ITEM
  // ================================
  static Future<void> modifyItem(
    ProductItem product, [
    String? newName,
    String? newCategoryId,
    String? newCategoryName,
    String? newDescription,
    List<String>? newIngredients,
    double? newPrice,
    double? newRating,
    String? newImageUrl,
    bool? newAvailability,
  ]) async {
    try {
      await _firestore
          .collection('Menu')
          .doc(product.categoryId)
          .collection('items')
          .doc(product.itemId)
          .update({
            'itemName': newName ?? product.itemName,
            'categoryId': newCategoryId ?? product.categoryId,
            'categoryName': newCategoryName ?? product.categoryName,
            'description': newDescription ?? product.description,
            'ingredients': newIngredients ?? product.ingredients,
            'price': newPrice ?? product.price,
            'rating': newRating ?? product.rating,
            'imageUrl': newImageUrl ?? product.imageUrl,
            'isAvailable': newAvailability ?? product.isAvailable,
          });
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  // ================================
  // DELETE ITEM
  // ================================
  static Future<void> deleteItem(ProductItem product) async {
    try {
      await _firestore
          .collection('Menu')
          .doc(product.categoryId)
          .collection('items')
          .doc(product.itemId)
          .delete();
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  // --------------------------------------------------ORDER CRUD-------------------------------------------------------

  // ================================
  // FETCH ALL ORDERS --> ADMIN
  // ================================
  static Future<List<OrderModel>> fetchAllOrders() async {
    try {
      final querySnapshot = await _firestore.collection('cart').get();

      if (querySnapshot.docs.isEmpty) return [];

      return querySnapshot.docs
          .map((doc) => OrderModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error: ${e.code}');
    }
  }

  // ================================
  // GET USER ORDERS -- USER
  // ================================
  static Future<List<OrderModel>> getUserOrders(String userID) async {
    try {
      final querySnapshot = await _firestore
          .collection('cart')
          .where('userID', isEqualTo: userID)
          .get();

      if (querySnapshot.docs.isEmpty) return [];

      return querySnapshot.docs
          .map((doc) => OrderModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error: ${e.code}');
    }
  }

  // ================================
  // MAKE ORDER
  // ================================
  static Future<void> makeOrder(OrderModel order) async {
    try {
      final orderRef = _firestore.collection('cart').doc();
      order.orderID = orderRef.id;

      await orderRef.set(order.toMap());
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  // ================================
  // MODIFY ORDER STATUS
  // ================================
  static Future<void> modifyOrder(
    OrderModel order, [
    String? newItemID,
    String? newUserID,
    String? newStatus,
    double? newRate,
    List<String>? newIngredients,
  ]) async {
    try {
      await _firestore.collection('cart').doc(order.orderID).update({
        'itemID': newItemID ?? order.itemID,
        'userID': newUserID ?? order.userID,
        'status': newStatus ?? order.status,
        'rate': newRate ?? order.rate,
        'ingredients': newIngredients ?? order.ingredients,
      });
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  // ================================
  // DELETE ORDER
  // ================================
  static Future<void> deleteOrder(String orderID) async {
    try {
      await _firestore.collection('cart').doc(orderID).delete();
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  // ================================
  // DELETE ALL USER ORDERS
  // ================================
  static Future<void> deleteAllUserOrders(String userID) async {
    try {
      final querySnapshot = await _firestore
          .collection('cart')
          .where('userID', isEqualTo: userID)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }
}
