import 'package:foodapp/service/isar_local/menu_local_service.dart';
import 'package:foodapp/service/supabase_remote/supabase_service.dart';

class MenuRemoteService {
  /// listen to any change in the remote menu
  static void listenToMenuChanges() {
    SupabaseService.client.from('menu_items').stream(primaryKey: ['id']).listen(
      (rows) async {
        for (final row in rows) {
          await MenuLocalService.upsertFromRemote(row);
        }
      },
    );
  }

  /// 📥 fetch available items
  Future<List<Map<String, dynamic>>> fetchMenu() async {
    final res = await SupabaseService.client
        .from('menu_items')
        .select()
        .eq('available', true);

    return List<Map<String, dynamic>>.from(res);
  }

  /// ➕ add item (Supabase generates id)
  Future<Map<String, dynamic>> addItem({
    required String name,
    required String description,
    required double price,
    required int categoryId,
    required String imageUrl,
    required String ingreidents,
    bool available = false,
  }) async {
    final res = await SupabaseService.client
        .from('menu_items')
        .insert({
          'name': name,
          'description': description,
          'price': price,
          'category_id': categoryId,
          'image_url': imageUrl,
          'ingreident': ingreidents,
          'available': available,
        })
        .select()
        .single();
    return res;
  }

  /// ✏️ update item
  Future<void> updateItem({
    required int itemId,
    String? name,
    String? description,
    double? price,
    int? categoryId,
    String? imageUrl,
    String? ingreidents,
    bool? available,
  }) async {
    final data = <String, dynamic>{};

    if (name != null) data['name'] = name;
    if (description != null) data['description'] = description;
    if (price != null) data['price'] = price;
    if (categoryId != null) data['category_id'] = categoryId;
    if (imageUrl != null) data['image_url'] = imageUrl;
    if (ingreidents != null) data['ingreident'] = ingreidents;
    if (available != null) data['available'] = available;

    if (data.isEmpty) return;

    await SupabaseService.client
        .from('menu_items')
        .update(data)
        .eq('id', itemId);
  }

  /// 🗑️ delete item
  Future<void> deleteItem(int itemId) async {
    await SupabaseService.client.from('menu_items').delete().eq('id', itemId);
  }

  /// 📥 fetch categories
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final res = await SupabaseService.client
        .from('categories')
        .select()
        .order('created_at');

    return List<Map<String, dynamic>>.from(res);
  }

  /// ➕ add category
  Future<Map<String, dynamic>> addCategory({
    required String name,
    required String imageUrl,
  }) async {
    final res = await SupabaseService.client
        .from('categories')
        .insert({'name': name, 'image_url': imageUrl})
        .select()
        .single();

    return res;
  }

  /// ✏️ update category
  Future<void> updateCategory({
    required int categoryId,
    String? name,
    String? imageUrl,
  }) async {
    final data = <String, dynamic>{};

    if (name != null) data['name'] = name;
    if (imageUrl != null) data['image_url'] = imageUrl;

    if (data.isEmpty) return;

    await SupabaseService.client
        .from('categories')
        .update(data)
        .eq('id', categoryId);
  }

  /// 🗑️ delete category
  Future<void> deleteCategory(int categoryId) async {
    await SupabaseService.client
        .from('categories')
        .delete()
        .eq('id', categoryId)
        .select();
  }
}
