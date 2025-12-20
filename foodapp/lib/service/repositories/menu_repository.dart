import 'package:flutter/material.dart';
import 'package:foodapp/models/category%20model/category_model.dart';
import 'package:foodapp/models/item%20model/item_model.dart';
import 'package:foodapp/service/isar_local/menu_local_service.dart';
import 'package:foodapp/service/supabase_remote/menu_remote_service.dart';

class MenuRepository {
  final _remote = MenuRemoteService();
  final _local = MenuLocalService();

  /// 🔄 sync menu from remote to local (offline-safe)
  Future<void> syncMenu() async {
    try {
      final remoteMenu = await _remote.fetchMenu().timeout(
        const Duration(seconds: 5),
      );

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

      await _local.saveMenu(localItems);
    } catch (e) {
      debugPrint('Failed to fetch menu: $e');
    }
  }

  /// 👀 UI reads Isar only
  Stream<List<ItemModel>> watchLocalMenu() => _local.watchMenu();

  /// 👀 Isar reads Supabase
  void watchRemoteMenu() {
    _remote.listenToMenuChanges().listen(
      (rows) async {
        try {
          await _local.upsertFromRemote(rows);
        } catch (e) {
          debugPrint('Failed to update local menu : $e');
        }
      },
      onError: (error) {
        debugPrint('Menu stream error : $error');
      },
    );
  }

  /// ➕ add menu item (offline-safe: local will update anyway)
  Future<void> add(ItemModel item) async {
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
          .timeout(const Duration(seconds: 5));

      item.itemId = res['id'];
      await _local.upsertItem(item);
    } catch (e) {
      debugPrint('Failed to add item remotely: $e');
    }
  }

  /// ✏️ update menu item
  Future<void> update(ItemModel item) async {
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
          .timeout(const Duration(seconds: 5));
      await _local.upsertItem(item);
    } catch (e) {
      debugPrint('Failed to update item remotely: $e');
    }
  }

  /// 🗑️ delete menu item
  Future<void> delete(ItemModel item) async {
    try {
      await _remote.deleteItem(item.itemId).timeout(const Duration(seconds: 5));
      await _local.deleteItemByItemId(item.itemId);
    } catch (e) {
      debugPrint('Failed to delete item remotely: $e');
    }
  }

  /// 👀 UI reads Isar only
  Stream<List<CategoryModel>> watchCategories() => _local.watchCategories();

  /// 🔄 sync categories (offline-safe)
  Future<void> syncCat() async {
    try {
      final remote = await _remote.fetchCategories().timeout(
        const Duration(seconds: 5),
      );

      final categories = remote.map((e) {
        return CategoryModel()
          ..categoryId = e['id']
          ..name = e['name']
          ..imageUrl = e['image_url']
          ..createdAt = DateTime.parse(e['created_at']);
      }).toList();

      await _local.replaceAll(categories);
    } catch (e) {
      debugPrint('Failed to fetch categories: $e');
    }
  }

  /// ➕ add category
  Future<void> addCat(CategoryModel category) async {
    try {
      final res = await _remote
          .addCategory(name: category.name, imageUrl: category.imageUrl)
          .timeout(const Duration(seconds: 5));

      category.categoryId = res['id'];
      category.createdAt = DateTime.parse(res['created_at']);
      await _local.upsertCat(category);
    } catch (e) {
      debugPrint('Failed to add category remotely: $e');
    }
  }

  /// ✏️ update category
  Future<void> updateCat(CategoryModel category) async {
    try {
      await _remote
          .updateCategory(
            categoryId: category.categoryId,
            name: category.name,
            imageUrl: category.imageUrl,
          )
          .timeout(const Duration(seconds: 5));
      await _local.upsertCat(category);
    } catch (e) {
      debugPrint('Failed to update category remotely: $e');
    }
  }

  /// 🗑️ delete category
  Future<void> deleteCat(CategoryModel category) async {
    try {
      await _remote
          .deleteCategory(category.categoryId)
          .timeout(const Duration(seconds: 5));
      await _local.deleteByCategoryId(category.categoryId);
    } catch (e) {
      debugPrint('Failed to delete category remotely: $e');
    }
  }
}
