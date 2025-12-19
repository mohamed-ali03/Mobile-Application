import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restaurant/feature/local_database/app%20status/app_status_entity.dart';
import 'package:restaurant/feature/local_database/category/category_entity.dart';
import 'package:restaurant/feature/local_database/order/order_entity.dart';
import 'package:restaurant/feature/local_database/product%20item/product_item_entity.dart';
import 'package:restaurant/feature/local_database/user/user_entity.dart';

class LocalDatabaseService {
  static final LocalDatabaseService _instance =
      LocalDatabaseService._internal();
  factory LocalDatabaseService() => _instance;
  LocalDatabaseService._internal();

  late Isar isar;

  // Init local database
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      AppStatusEntitySchema,
      CategoryEntitySchema,
      OrderEntitySchema,
      ProductItemEntitySchema,
      UserEntitySchema,
    ], directory: dir.path);
  }

  // =========================
  // APP STATUS
  // =========================
  // Store app status
  Future<void> storeAppStatus(AppStatusEntity status) async {
    await isar.writeTxn(() async {
      await isar.appStatusEntitys.put(status);
    });
  }

  // Fetch app status
  Future<AppStatusEntity?> fetchAppStatus() async {
    return await isar.appStatusEntitys.where().findFirst();
  }

  // Update app status
  Future<void> updateAppStatus(AppStatusEntity status) async {
    await isar.writeTxn(() async {
      await isar.appStatusEntitys.put(status);
    });
  }

  // Delete app status
  Future<void> deleteAppStatus(int id) async {
    await isar.writeTxn(() async {
      await isar.appStatusEntitys.delete(id);
    });
  }

  // =========================
  // MENU
  // =========================
  // Store categories
  Future<void> storeCategories(List<CategoryEntity> categories) async {
    await isar.writeTxn(() async {
      await isar.categoryEntitys.putAll(categories);
    });
  }

  // Fetch all categories
  Future<List<CategoryEntity>> fetchCategories() async {
    return await isar.categoryEntitys.where().findAll();
  }

  // Delete all categories
  Future<void> deleteCategories() async {
    await isar.writeTxn(() async {
      await isar.categoryEntitys.clear();
    });
  }

  // =========================
  // USERS
  // =========================
  // Store Users
  Future<void> storeUsers(List<UserEntity> users) async {
    await isar.writeTxn(() async {
      await isar.userEntitys.putAll(users);
    });
  }

  // Fetch all users
  Future<List<UserEntity>> fetchAllUsers() async {
    return await isar.userEntitys.where().findAll();
  }

  // Delete Users
  Future<void> deleteUsers() async {
    await isar.writeTxn(() async {
      await isar.userEntitys.clear();
    });
  }

  // =========================
  // CURRENT USER
  // =========================
  // Store user
  Future<void> storeUser(UserEntity user) async {
    await isar.writeTxn(() async {
      await isar.userEntitys.put(user);
    });
  }

  // Fetch user by UID
  Future<UserEntity?> fetchUser(String uid) async {
    return await isar.userEntitys.where().uidEqualTo(uid).findFirst();
  }

  // Delete user
  Future<void> deleteUser(String uid) async {
    final user = await fetchUser(uid);
    if (user != null) {
      await isar.writeTxn(() async {
        await isar.userEntitys.delete(user.id);
      });
    }
  }

  // =========================
  // ORDERS
  // =========================
  // Store orders
  Future<void> storeOrders(List<OrderEntity> orders) async {
    await isar.writeTxn(() async {
      await isar.orderEntitys.putAll(orders);
    });
  }

  // Fetch all orders
  Future<List<OrderEntity>> fetchOrders() async {
    return await isar.orderEntitys.where().findAll();
  }

  // Fetch orders by user
  Future<List<OrderEntity>> fetchOrdersByUser(String uid) async {
    return await isar.orderEntitys.where().userIdEqualTo(uid).findAll();
  }

  // Delete order
  Future<void> deleteOrder(String orderId) async {
    final order = await isar.orderEntitys
        .where()
        .orderIdEqualTo(orderId)
        .findFirst();
    if (order != null) {
      await isar.writeTxn(() async {
        await isar.orderEntitys.delete(order.id);
      });
    }
  }

  // =========================
  // ITEMS
  // =========================
  // Store products
  Future<void> storeProducts(List<ProductItemEntity> products) async {
    await isar.writeTxn(() async {
      await isar.productItemEntitys.putAll(products);
    });
  }

  // Fetch all products
  Future<List<ProductItemEntity>> fetchProducts() async {
    return await isar.productItemEntitys.where().findAll();
  }

  // Fetch products by categoryId
  Future<List<ProductItemEntity>> fetchProductsByCategory(
    String categoryId,
  ) async {
    return await isar.productItemEntitys
        .where()
        .categoryIdEqualTo(categoryId)
        .findAll();
  }

  // Delete all products
  Future<void> deleteProducts() async {
    await isar.writeTxn(() async {
      await isar.productItemEntitys.clear();
    });
  }
}
