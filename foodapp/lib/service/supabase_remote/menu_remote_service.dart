import 'package:flutter/material.dart';
import 'package:foodapp/service/supabase_remote/supabase_service.dart';

class MenuRemoteService {
  /// 📥 fetch available items
  Future<List<Map<String, dynamic>>> fetchMenu({
    bool onlyAvailable = false,
  }) async {
    try {
      var query = SupabaseService.client.from('menu_items').select();

      if (onlyAvailable) {
        query = query.eq('available', true);
      }

      final res = await query;
      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      debugPrint('Error fetching menu: $e');
      rethrow;
    }
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
    try {
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
    } catch (e) {
      debugPrint('Error adding item: $e');
      rethrow;
    }
  }

  /// ✏️ update item
  Future<Map<String, dynamic>> updateItem({
    required int itemId,
    String? name,
    String? description,
    double? price,
    int? categoryId,
    String? imageUrl,
    String? ingreidents,
    bool? available,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (name != null) data['name'] = name;
      if (description != null) data['description'] = description;
      if (price != null) data['price'] = price;
      if (categoryId != null) data['category_id'] = categoryId;
      if (imageUrl != null) data['image_url'] = imageUrl;
      if (ingreidents != null) data['ingreident'] = ingreidents;
      if (available != null) data['available'] = available;

      if (data.isEmpty) return <String, dynamic>{};

      final res = await SupabaseService.client
          .from('menu_items')
          .update(data)
          .eq('id', itemId)
          .select()
          .single();

      return res;
    } catch (e) {
      debugPrint('Error updating item: $e');
      rethrow;
    }
  }

  /// 🗑️ delete item
  Future<void> deleteItem(int itemId) async {
    try {
      await SupabaseService.client.from('menu_items').delete().eq('id', itemId);
    } catch (e) {
      debugPrint('Error deleting item: $e');
      rethrow;
    }
  }

  /// 📥 fetch categories
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final res = await SupabaseService.client
          .from('categories')
          .select()
          .order('created_at');

      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      rethrow;
    }
  }

  /// ➕ add category
  Future<Map<String, dynamic>> addCategory({required String name}) async {
    try {
      final res = await SupabaseService.client
          .from('categories')
          .insert({'name': name})
          .select()
          .single();

      return res;
    } catch (e) {
      debugPrint('Error adding category: $e');
      rethrow;
    }
  }

  /// ✏️ update category
  Future<Map<String, dynamic>> updateCategory({
    required int categoryId,
    String? name,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (name != null) data['name'] = name;

      if (data.isEmpty) return <String, dynamic>{};

      final res = await SupabaseService.client
          .from('categories')
          .update(data)
          .eq('id', categoryId)
          .select()
          .single();

      return res;
    } catch (e) {
      debugPrint('Error updating category: $e');
      rethrow;
    }
  }

  /// 🗑️ delete category
  Future<void> deleteCategory(int categoryId) async {
    try {
      await SupabaseService.client
          .from('categories')
          .delete()
          .eq('id', categoryId);
    } catch (e) {
      debugPrint('Error deleting category: $e');
      rethrow;
    }
  }
}
