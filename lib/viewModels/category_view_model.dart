import 'package:appfp_task_manager/models/category.dart';
import 'package:appfp_task_manager/service/category_service.dart';
import 'package:flutter/material.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categorys = [];
  List<Category> get categorys => _categorys;

  final List<Category> _filterCategorys = [];
  List<Category> get filterCategorys => _filterCategorys;

  Category? _category;
  Category? get category => _category;

  bool isLoading = false;

  CategoryViewModel() {
    _fetchCategorys();
  }

  // 取得分類清單
  Future<void> _fetchCategorys() async {
    List<Category> categorys = await _categoryService.getCategorys();

    _categorys = categorys;
    setFilterCategory();
    if (categorys.isNotEmpty) {
      setCategory(_filterCategorys[0]);
    }
    notifyListeners();
  }

  setFilterCategory() {
    final item = Category(id: '0', title: '全部');
    _filterCategorys.add(item);
    _filterCategorys.addAll(_categorys);
  }

  // 設定預設選項
  setCategory(Category? category) {
    _category = category;
  }
}
