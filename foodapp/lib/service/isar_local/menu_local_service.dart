import 'package:flutter/material.dart';
import 'package:foodapp/models/category%20model/category_model.dart';
import 'package:foodapp/models/item%20model/item_model.dart';
import 'package:foodapp/service/isar_local/isar_service.dart';
import 'package:isar/isar.dart';

class MenuLocalService {
  /// 📝 save/sync menu items (clears old data)
  Future<void> saveItems(List<ItemModel> items) async {
    try {
      await IsarService.isar.writeTxn(() async {
        await IsarService.isar.itemModels.clear();
        await IsarService.isar.itemModels.putAll(items);
      });
    } catch (e) {
      debugPrint('Error saving items: $e');
      rethrow;
    }
  }

  /// 👀 watch menu items
  Stream<List<ItemModel>> watchMenu() {
    try {
      final items = IsarService.isar.itemModels
          .where()
          .sortByCategoryId()
          .watch(fireImmediately: true);

      return items;
    } catch (e) {
      debugPrint('Error watching menu: $e');
      rethrow;
    }
  }

  /// 🔍 get item by remote id
  Future<ItemModel?> getItemByItemId(int itemId) async {
    try {
      return await IsarService.isar.itemModels
          .filter()
          .itemIdEqualTo(itemId)
          .findFirst();
    } catch (e) {
      debugPrint('Error getting item by id: $e');
      return null;
    }
  }

  /// ➕ upsert item (insert or update)
  Future<void> upsertItem(ItemModel item) async {
    try {
      await IsarService.isar.writeTxn(() async {
        final existing = await getItemByItemId(item.itemId);
        if (existing != null) {
          item.id = existing.id;
        }
        await IsarService.isar.itemModels.put(item);
      });
    } catch (e) {
      debugPrint('Error upserting item: $e');
      rethrow;
    }
  }

  /// 🗑️ delete item by remote id
  Future<void> deleteItemByItemId(int itemId) async {
    try {
      await IsarService.isar.writeTxn(() async {
        final item = await getItemByItemId(itemId);
        if (item != null) {
          await IsarService.isar.itemModels.delete(item.id);
        }
      });
    } catch (e) {
      debugPrint('Error deleting item: $e');
      rethrow;
    }
  }

  /// 📝 save/sync categories (clears old data)
  Future<void> saveCats(List<CategoryModel> categories) async {
    try {
      await IsarService.isar.writeTxn(() async {
        await IsarService.isar.categoryModels.clear();
        await IsarService.isar.categoryModels.putAll(categories);
      });
    } catch (e) {
      debugPrint('Error saving categories: $e');
      rethrow;
    }
  }

  /// 👀 watch categories
  Stream<List<CategoryModel>> watchCategories() {
    try {
      final cats = IsarService.isar.categoryModels.where().watch(
        fireImmediately: true,
      );

      return cats;
    } catch (e) {
      debugPrint('Error watching categories: $e');
      rethrow;
    }
  }

  /// 🔍 get category by remote id
  Future<CategoryModel?> getCatByCategoryId(int categoryId) async {
    try {
      return await IsarService.isar.categoryModels
          .filter()
          .categoryIdEqualTo(categoryId)
          .findFirst();
    } catch (e) {
      debugPrint('Error getting category by id: $e');
      return null;
    }
  }

  /// ➕ upsert category (insert or update)
  Future<void> upsertCat(CategoryModel category) async {
    try {
      await IsarService.isar.writeTxn(() async {
        final existing = await getCatByCategoryId(category.categoryId);
        if (existing != null) {
          category.id = existing.id;
        }
        await IsarService.isar.categoryModels.put(category);
      });
    } catch (e) {
      debugPrint('Error upserting category: $e');
      rethrow;
    }
  }

  /// 🗑️ delete category by remote id
  Future<void> deleteByCategoryId(int categoryId) async {
    try {
      await IsarService.isar.writeTxn(() async {
        final cat = await getCatByCategoryId(categoryId);
        if (cat != null) {
          await IsarService.isar.categoryModels.delete(cat.id);
        }
      });
    } catch (e) {
      debugPrint('Error deleting category: $e');
      rethrow;
    }
  }
}
