import 'package:test_app/presentation/pages/add_category/add_category_view.dart';

class CategoryModel {
  int? id;
  late String name;
  late String type; // 'income' or 'expense'
  late DateTime createdAt;
  DateTime? updatedAt;

  CategoryModel({
    this.id,
    required this.name,
    required this.type,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert model to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Create model from Map from database
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  // Convert CategoryType to string
  static String categoryTypeToString(CategoryType type) {
    return type == CategoryType.income ? 'income' : 'expense';
  }

  // Convert string to CategoryType
  static CategoryType stringToCategoryType(String type) {
    return type == 'income' ? CategoryType.income : CategoryType.expense;
  }
}
