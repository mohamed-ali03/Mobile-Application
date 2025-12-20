import 'package:foodapp/models/category%20model/category_model.dart';
import 'package:foodapp/models/item%20model/item_model.dart';
import 'package:foodapp/service/isar_local/isar_service.dart';
import 'package:isar/isar.dart';

class MenuLocalService {
  Future<void> upsertFromRemote(List<Map<String, dynamic>> data) async {
    await IsarService.isar.writeTxn(() async {
      for (final row in data) {
        final item = ItemModel()
          ..itemId = row['id']
          ..categoryId = row['category_id']
          ..name = row['name']
          ..description = row['description']
          ..price = (row['price'] as num).toDouble()
          ..imageUrl = row['image_url']
          ..ingreidents = row['ingreident']
          ..available = row['available']
          ..createdAt = DateTime.parse(row['created_at']);

        final existing = await IsarService.isar.itemModels
            .filter()
            .itemIdEqualTo(item.itemId)
            .findFirst();

        if (existing != null) {
          item.id = existing.id;
        }
        await IsarService.isar.itemModels.put(item);
      }
    });
  }

  Future<void> saveMenu(List<ItemModel> items) async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.itemModels.clear();
      await IsarService.isar.itemModels.putAll(items);
    });
  }

  Stream<List<ItemModel>> watchMenu() {
    return IsarService.isar.itemModels.where().sortByCategoryId().watch(
      fireImmediately: true,
    );
  }

  /// 🔍 get by remote id
  Future<ItemModel?> getItemByItemId(int itemId) {
    return IsarService.isar.itemModels
        .filter()
        .itemIdEqualTo(itemId)
        .findFirst();
  }

  Future<void> upsertItem(ItemModel item) async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.itemModels.put(item);
    });
  }

  /// 🗑️ delete by remote id
  Future<void> deleteItemByItemId(int itemId) async {
    await IsarService.isar.writeTxn(() async {
      final item = await getItemByItemId(itemId);
      if (item != null) {
        await IsarService.isar.itemModels.delete(item.id);
      }
    });
  }

  /// 🔄 replace all (sync)
  Future<void> replaceAll(List<CategoryModel> categories) async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.categoryModels.clear();
      await IsarService.isar.categoryModels.putAll(categories);
    });
  }

  /// 👀 watch categories
  Stream<List<CategoryModel>> watchCategories() {
    return IsarService.isar.categoryModels.where().watch(fireImmediately: true);
  }

  /// 🔍 get by remote id
  Future<CategoryModel?> getCatByCategoryId(int categoryId) {
    return IsarService.isar.categoryModels
        .filter()
        .categoryIdEqualTo(categoryId)
        .findFirst();
  }

  /// ➕ add or update
  Future<void> upsertCat(CategoryModel category) async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.categoryModels.put(category);
    });
  }

  /// 🗑️ delete by remote id
  Future<void> deleteByCategoryId(int categoryId) async {
    await IsarService.isar.writeTxn(() async {
      final cat = await getCatByCategoryId(categoryId);
      if (cat != null) {
        await IsarService.isar.categoryModels.delete(cat.id);
      }
    });
  }
}
