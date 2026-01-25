import 'package:flutter/material.dart';
import 'package:foodapp/models/category%20model/category_model.dart';
import 'package:foodapp/models/category%20model/category_parse.dart';
import 'package:foodapp/models/item%20model/item_model.dart';
import 'package:foodapp/models/item%20model/item_parse.dart';
import 'package:foodapp/service/isar_local/menu_local_service.dart';
import 'package:foodapp/service/supabase_remote/menu_remote_service.dart';
import 'package:foodapp/service/supabase_remote/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MenuRepository {
  final _remote = MenuRemoteService();
  final _local = MenuLocalService();

  RealtimeChannel? _itemsChannel;
  RealtimeChannel? _categoryChannel;

  /// clear all local menu data (for logout)
  Future<void> clearAllMenuData() async {
    try {
      await _local.clearAllMenuData();
    } catch (e) {
      debugPrint('Error clearing local menu data: $e');
      rethrow;
    }
  }

  /// 🔔 listen to changes in items table [insert, update, delete]
  void listenToChangesInItemsTable() {
    try {
      _itemsChannel = SupabaseService.client
          .channel('public:menu_items')
          .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'menu_items',
            callback: (payload) {
              _local
                  .upsertItem(ItemModelJson.fromJson(payload.newRecord))
                  .catchError((e) {
                    debugPrint('Error syncing inserted item: $e');
                  });
            },
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'menu_items',
            callback: (payload) {
              _local
                  .upsertItem(ItemModelJson.fromJson(payload.newRecord))
                  .catchError((e) {
                    debugPrint('Error syncing updated item: $e');
                  });
            },
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.delete,
            schema: 'public',
            table: 'menu_items',
            callback: (payload) {
              _local.deleteItemByItemId(payload.oldRecord['id']).catchError((
                e,
              ) {
                debugPrint('Error syncing deleted item: $e');
              });
            },
          )
          .subscribe();
    } catch (e) {
      debugPrint('Error setting up items listener: $e');
      rethrow;
    }
  }

  /// 🔔 listen to changes in category table [insert, update, delete]
  void listenToChangesInCategoryTable() {
    try {
      _categoryChannel = SupabaseService.client
          .channel('public:category')
          .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'category',
            callback: (payload) {
              _local
                  .upsertCat(CategoryModelJson.fromJson(payload.newRecord))
                  .catchError((e) {
                    debugPrint('Error syncing inserted category: $e');
                  });
            },
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'category',
            callback: (payload) {
              _local
                  .upsertCat(CategoryModelJson.fromJson(payload.newRecord))
                  .catchError((e) {
                    debugPrint('Error syncing updated category: $e');
                  });
            },
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.delete,
            schema: 'public',
            table: 'category',
            callback: (payload) {
              _local.deleteByCategoryId(payload.oldRecord['id']).catchError((
                e,
              ) {
                debugPrint('Error syncing deleted category: $e');
              });
            },
          )
          .subscribe();
    } catch (e) {
      debugPrint('Error setting up category listener: $e');
      rethrow;
    }
  }

  /// 🧹 cleanup subscriptions
  Future<void> dispose() async {
    try {
      if (_itemsChannel != null) {
        await SupabaseService.client.removeChannel(_itemsChannel!);
      }
      if (_categoryChannel != null) {
        await SupabaseService.client.removeChannel(_categoryChannel!);
      }
    } catch (e) {
      debugPrint('Error disposing MenuRepository: $e');
      rethrow;
    }
  }

  /// 🔄 sync menu from remote to local (offline-safe)
  Future<void> syncMenu() async {
    try {
      final remoteMenu = await _remote.fetchMenu();

      final localItems = remoteMenu.map((e) {
        return ItemModel()
          ..itemId = e['id']
          ..name = e['name']
          ..description = e['description']
          ..price = (e['price'] as num).toDouble()
          ..imageUrl = e['image_url']
          ..categoryId = e['category_id']
          ..available = e['available']
          ..ingreidents = e['ingreident']
          ..createdAt = DateTime.parse(e['created_at']);
      }).toList();

      await _local.saveItems(localItems);
    } catch (e) {
      debugPrint('Failed to sync menu: $e');
      rethrow;
    }
  }

  /// 👀 UI reads Isar only
  Stream<List<ItemModel>> watchLocalMenu() {
    try {
      return _local.watchMenu();
    } catch (e) {
      debugPrint('Error watching local menu: $e');
      rethrow;
    }
  }

  Future<ItemModel?> getItem(int itemId) async {
    try {
      return await _local.getItemByItemId(itemId);
    } catch (e) {
      rethrow;
    }
  }

  /// ➕ add menu item
  Future<void> addItem(ItemModel item) async {
    try {
      final res = await _remote
          .addItem(
            name: item.name,
            description: item.description,
            price: item.price,
            categoryId: item.categoryId,
            imageUrl: item.imageUrl,
            ingreidents: item.ingreidents,
            available: item.available,
          )
          .timeout(const Duration(seconds: 10));

      item.itemId = res['id'];
      await _local.upsertItem(item);
    } catch (e) {
      debugPrint('Failed to add item: $e');
      rethrow;
    }
  }

  /// ✏️ update menu item (listener will sync to local)
  Future<void> updateItem(ItemModel item) async {
    try {
      await _remote
          .updateItem(
            itemId: item.itemId,
            name: item.name,
            description: item.description,
            price: item.price,
            categoryId: item.categoryId,
            imageUrl: item.imageUrl,
            ingreidents: item.ingreidents,
            available: item.available,
          )
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint('Failed to update item (id: ${item.itemId}): $e');
      rethrow;
    }
  }

  /// 🗑️ delete menu item (listener will sync to local)
  Future<void> deleteItem(ItemModel item) async {
    try {
      await _remote
          .deleteItem(item.itemId)
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint('Failed to delete item (id: ${item.itemId}): $e');
      rethrow;
    }
  }

  /// 👀 UI reads Isar only
  Stream<List<CategoryModel>> watchCategories() {
    try {
      return _local.watchCategories();
    } catch (e) {
      debugPrint('Error watching categories: $e');
      rethrow;
    }
  }

  /// 🔄 sync categories (offline-safe)
  Future<void> syncCat() async {
    try {
      final remote = await _remote.fetchCategories().timeout(
        const Duration(seconds: 10),
      );

      final categories = remote.map((e) {
        return CategoryModel()
          ..categoryId = e['id']
          ..name = e['name']
          ..createdAt = DateTime.parse(e['created_at']);
      }).toList();

      await _local.saveCats(categories);
    } catch (e) {
      debugPrint('Failed to sync categories: $e');
      rethrow;
    }
  }

  /// ➕ add category
  Future<void> addCat(CategoryModel category) async {
    try {
      final res = await _remote
          .addCategory(name: category.name)
          .timeout(const Duration(seconds: 10));

      category.categoryId = res['id'];
      category.createdAt = DateTime.parse(res['created_at']);
      await _local.upsertCat(category);
    } catch (e) {
      debugPrint('Failed to add category: $e');
      rethrow;
    }
  }

  /// ✏️ update category (listener will sync to local)
  Future<void> updateCat(CategoryModel category) async {
    try {
      await _remote
          .updateCategory(categoryId: category.categoryId, name: category.name)
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint('Failed to update category (id: ${category.categoryId}): $e');
      rethrow;
    }
  }

  /// 🗑️ delete category (listener will sync to local)
  Future<void> deleteCat(CategoryModel category) async {
    try {
      await _remote
          .deleteCategory(category.categoryId)
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint('Failed to delete category (id: ${category.categoryId}): $e');
      rethrow;
    }
  }
}
