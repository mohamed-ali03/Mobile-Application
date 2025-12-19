import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodapp/models/category%20model/category_model.dart';
import 'package:foodapp/models/item%20model/item_model.dart';
import 'package:foodapp/service/repositories/menu_repository.dart';

class MenuProvider extends ChangeNotifier {
  final _repo = MenuRepository();

  List<ItemModel> items = [];
  bool syncing = false;

  late StreamSubscription _sub;

  MenuProvider() {
    sync();
    _sub = _repo.watchMenu().listen((data) {
      items = data;
      notifyListeners();
    });
  }

  Future<void> sync() async {
    syncing = true;
    notifyListeners();

    await _repo.syncCat();
    await _repo.syncMenu();

    syncing = false;
    notifyListeners();
  }

  Future<void> addItem(ItemModel item) async {
    await _repo.add(item);
  }

  // ✏️ Update item
  Future<void> updateItem(ItemModel item) async {
    await _repo.update(item);
  }

  // 🗑️ Delete item
  Future<void> deleteItem(ItemModel item) async {
    await _repo.delete(item);
  }

  // add cat
  Future<void> addCat(CategoryModel category) async {
    await _repo.addCat(category);
  }

  // update cat
  Future<void> updateCat(CategoryModel category) async {
    await _repo.updateCat(category);
  }

  // delete cat
  Future<void> deleteCat(CategoryModel category) async {
    await _repo.deleteCat(category);
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
