import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/data/models/category_model.dart';
import 'package:test_app/data/repositories/category_repository.dart';
import 'package:test_app/presentation/controllers/categories/categories_controller.dart';
import 'package:test_app/presentation/pages/add_category/add_category_view.dart';

class AddCategoryController extends GetxController {
  late CategoryRepository _categoryRepository;
  final Rx<CategoryType> _character = CategoryType.income.obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final Rx<CategoryModel?> editingCategory = Rx<CategoryModel?>(null);
  late CategoriesController _categoriesController;

  Rx<CategoryType> get character => _character;

  @override
  void onInit() async {
    super.onInit();
    _categoryRepository = Get.find<CategoryRepository>();
    _categoriesController = Get.find<CategoriesController>();
    // await loadCategories();
  }

  void setCharacter(CategoryType? value) {
    if (value != null) {
      _character.value = value;
      update();
    }
  }

  TextEditingController categoryNameController = TextEditingController();

  // Add new category
  Future<void> addCategory() async {
    if (categoryNameController.text.isEmpty) {
      Get.snackbar('Error', 'Category name cannot be empty');
      return;
    }

    try {
      final categoryType = CategoryModel.categoryTypeToString(_character.value);
      final newCategory = CategoryModel(
        name: categoryNameController.text,
        type: categoryType,
      );

      await _categoryRepository.addCategory(newCategory);
      categoryNameController.clear();
      _character.value = CategoryType.income;
      await _categoriesController.loadCategories();
      Get.snackbar('Success', 'Category added successfully');
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to add category: $e');
      debugPrint('Error adding category: $e');
    }
  }

  // Update category
  Future<void> updateCategory(CategoryModel category) async {
    if (categoryNameController.text.isEmpty) {
      Get.snackbar('Error', 'Category name cannot be empty');
      return;
    }

    try {
      category.name = categoryNameController.text;
      category.type = CategoryModel.categoryTypeToString(_character.value);
      await _categoryRepository.updateCategory(category);
      categoryNameController.clear();
      _character.value = CategoryType.income;
      editingCategory.value = null;
      await _categoriesController.loadCategories();

      Get.snackbar('Success', 'Category updated successfully');
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update category: $e');
      debugPrint('Error updating category: $e');
    }
  }

  // Delete category
  Future<void> deleteCategory(int id) async {
    try {
      await _categoryRepository.deleteCategory(id);
      await _categoriesController.loadCategories();

      // await loadCategories();
      Get.snackbar('Success', 'Category deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete category: $e');
      debugPrint('Error deleting category: $e');
    }
  }

  // Set category for editing
  void setEditingCategory(CategoryModel category) {
    editingCategory.value = category;
    categoryNameController.text = category.name;
    _character.value = CategoryModel.stringToCategoryType(category.type);
    update();
  }

  // Clear editing
  void clearEditing() {
    editingCategory.value = null;
    categoryNameController.clear();
    _character.value = CategoryType.income;
    update();
  }

  @override
  void onClose() {
    editingCategory.value = null;
    categoryNameController.clear();
    _character.value = CategoryType.income;
    categoryNameController.dispose();
    super.onClose();
  }
}
