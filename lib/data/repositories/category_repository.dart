import 'package:test_app/data/datasources/category_local_datasource.dart';
import 'package:test_app/data/models/category_model.dart';

class CategoryRepository {
  final CategoryLocalDataSource _localDataSource;

  CategoryRepository(this._localDataSource);

  // Add category
  Future<void> addCategory(CategoryModel category) async {
    await _localDataSource.addCategory(category);
  }

  // Get all categories
  Future<List<CategoryModel>> getAllCategories() async {
    return await _localDataSource.getAllCategories();
  }

  // Get categories by type
  Future<List<CategoryModel>> getCategoriesByType(String type) async {
    return await _localDataSource.getCategoriesByType(type);
  }

  // Get category by id
  Future<CategoryModel?> getCategoryById(int id) async {
    return await _localDataSource.getCategoryById(id);
  }

  // Update category
  Future<void> updateCategory(CategoryModel category) async {
    await _localDataSource.updateCategory(category);
  }

  // Delete category
  Future<void> deleteCategory(int id) async {
    await _localDataSource.deleteCategory(id);
  }

  // Delete all categories
  Future<void> deleteAllCategories() async {
    await _localDataSource.deleteAllCategories();
  }
}
