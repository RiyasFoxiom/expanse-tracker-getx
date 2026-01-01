import 'package:test_app/data/datasources/local/database_helper.dart';
import 'package:test_app/data/models/transaction_model.dart';

class TransactionLocalDataSource {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Add transaction
  Future<int> addTransaction(TransactionModel transaction) async {
    final db = await _databaseHelper.database;
    return await db.insert('transactions', transaction.toMap());
  }

  // Get all transactions
  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('transactions');
    return List.generate(maps.length, (i) => TransactionModel.fromMap(maps[i]));
  }

  // Get transactions by date
  Future<List<TransactionModel>> getTransactionsByDate(DateTime date) async {
    final db = await _databaseHelper.database;
    final startDate = DateTime(date.year, date.month, date.day);
    final endDate = startDate.add(const Duration(days: 1));

    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'date >= ? AND date < ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
    );
    return List.generate(maps.length, (i) => TransactionModel.fromMap(maps[i]));
  }

  // Get transactions by category
  Future<List<TransactionModel>> getTransactionsByCategory(
    String category,
  ) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'category = ?',
      whereArgs: [category],
    );
    return List.generate(maps.length, (i) => TransactionModel.fromMap(maps[i]));
  }

  // Update transaction
  Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await _databaseHelper.database;
    transaction.updatedAt = DateTime.now();
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  // New: Get transactions by date range
  Future<List<TransactionModel>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'date >= ? AND date < ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
    );
    return List.generate(maps.length, (i) => TransactionModel.fromMap(maps[i]));
  }

  // New: Get transactions by bank
  Future<List<TransactionModel>> getTransactionsByBank(int bankId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'bank_id = ?',
      whereArgs: [bankId],
    );
    return List.generate(maps.length, (i) => TransactionModel.fromMap(maps[i]));
  }

  // Delete transaction
  Future<int> deleteTransaction(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllTransactions() async {
    final db = await _databaseHelper.database;
    await db.delete('transactions');
  }
}
