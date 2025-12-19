import 'package:foodapp/models/category%20model/category_model.dart';
import 'package:foodapp/models/item%20model/item_model.dart';
import 'package:foodapp/service/isar_local/menu_local_service.dart';
import 'package:foodapp/service/supabase_remote/menu_remote_service.dart';

class MenuRepository {
  final _remote = MenuRemoteService();
  final _local = MenuLocalService();

  Future<void> syncMenu() async {
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
        ..ingreidents = e['ingreident'];
    }).toList();

    await _local.saveMenu(localItems);
  }

  // watch any change in menu
  Stream<List<ItemModel>> watchMenu() => _local.watchMenu();

  // ➕ add
  Future<void> add(ItemModel item) async {
    final res = await _remote.addItem(
      name: item.name,
      description: item.description,
      price: item.price,
      categoryId: item.categoryId,
      imageUrl: item.imageUrl,
      ingreidents: item.ingreidents,
      available: item.available,
    );

    item.itemId = res['id'];
    await _local.upsertItem(item);
  }

  /// ✏️ update
  Future<void> update(ItemModel item) async {
    await _remote.updateItem(
      itemId: item.itemId,
      name: item.name,
      description: item.description,
      price: item.price,
      categoryId: item.categoryId,
      imageUrl: item.imageUrl,
      ingreidents: item.ingreidents,
      available: item.available,
    );

    await _local.upsertItem(item);
  }

  /// 🗑️ delete
  Future<void> delete(ItemModel item) async {
    await _remote.deleteItem(item.itemId);
    await _local.deleteItemByItemId(item.itemId);
  }

  /// 👀 UI reads Isar only
  Stream<List<CategoryModel>> watchCategories() => _local.watchCategories();

  /// 🔄 initial sync
  Future<void> syncCat() async {
    final remote = await _remote.fetchCategories();

    final categories = remote.map((e) {
      return CategoryModel()
        ..categoryId = e['id']
        ..name = e['name']
        ..imageUrl = e['image_url']
        ..createdAt = DateTime.parse(e['created_at']);
    }).toList();

    await _local.replaceAll(categories);
  }

  /// ➕ add
  Future<void> addCat(CategoryModel category) async {
    final res = await _remote.addCategory(
      name: category.name,
      imageUrl: category.imageUrl,
    );

    category.categoryId = res['id'];
    category.createdAt = DateTime.parse(res['created_at']);

    await _local.upsertCat(category);
  }

  /// ✏️ update
  Future<void> updateCat(CategoryModel category) async {
    await _remote.updateCategory(
      categoryId: category.categoryId,
      name: category.name,
      imageUrl: category.imageUrl,
    );

    await _local.upsertCat(category);
  }

  /// 🗑️ delete
  Future<void> deleteCat(CategoryModel category) async {
    await _remote.deleteCategory(category.categoryId);
    await _local.deleteByCategoryId(category.categoryId);
  }
}
