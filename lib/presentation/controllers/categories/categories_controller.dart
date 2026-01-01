import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/data/models/category_model.dart';
import 'package:test_app/data/repositories/category_repository.dart';

class CategoriesController extends GetxController {
  late CategoryRepository _categoryRepository;

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _categoryRepository = Get.find<CategoryRepository>();
    loadCategories();
  }

  // Load all categories
  Future<void> loadCategories() async {
    try {
      isLoading.value = true;
      final result = await _categoryRepository.getAllCategories();
      categories.assignAll(result);
    } catch (e) {
      debugPrint('Error loading categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Delete category
  Future<void> deleteCategory(int id) async {
    try {
      await _categoryRepository.deleteCategory(id);
      await loadCategories(); // Refresh the list
      Get.snackbar('Success', 'Category deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete category: $e');
      debugPrint('Error deleting category: $e');
    }
  }

  // Get categories by type
  Future<void> loadCategoriesByType(String type) async {
    try {
      isLoading.value = true;
      final result = await _categoryRepository.getCategoriesByType(type);
      categories.assignAll(result);
    } catch (e) {
      debugPrint('Error loading categories by type: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
