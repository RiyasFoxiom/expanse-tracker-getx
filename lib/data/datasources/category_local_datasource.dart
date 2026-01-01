import 'package:test_app/data/datasources/local/database_helper.dart';
import 'package:test_app/data/models/category_model.dart';

class CategoryLocalDataSource {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Get all categories
  Future<List<CategoryModel>> getAllCategories() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(maps.length, (i) => CategoryModel.fromMap(maps[i]));
  }

  // Get categories by type
  Future<List<CategoryModel>> getCategoriesByType(String type) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: 'type = ?',
      whereArgs: [type],
    );
    return List.generate(maps.length, (i) => CategoryModel.fromMap(maps[i]));
  }

  // Get category by id
  Future<CategoryModel?> getCategoryById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) {
      return null;
    }
    return CategoryModel.fromMap(maps.first);
  }

  // Add category
  Future<int> addCategory(CategoryModel category) async {
    final db = await _databaseHelper.database;
    return await db.insert('categories', category.toMap());
  }

  // Update category
  Future<int> updateCategory(CategoryModel category) async {
    final db = await _databaseHelper.database;
    category.updatedAt = DateTime.now();
    return await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  // Delete category
  Future<int> deleteCategory(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  // Delete all categories
  Future<int> deleteAllCategories() async {
    final db = await _databaseHelper.database;
    return await db.delete('categories');
  }

  // Close database
  Future<void> closeDatabase() async {
    await _databaseHelper.close();
  }
}
