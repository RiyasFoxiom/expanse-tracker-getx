// data/datasources/bank_local_datasource.dart
import 'package:test_app/data/models/bank_model.dart';
import 'package:test_app/data/datasources/local/database_helper.dart';

class BankLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<BankModel>> getAllBanks() async {
    final db = await _dbHelper.database;
    final maps = await db.query('banks');
    return maps.map((m) => BankModel.fromMap(m)).toList();
  }

  Future<int> addBank(BankModel bank) async {
    final db = await _dbHelper.database;
    return await db.insert('banks', bank.toMap());
  }

  Future<int> updateBankBalance(int id, double newBalance) async {
    final db = await _dbHelper.database;
    return await db.update(
      'banks',
      {'balance': newBalance, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<BankModel?> getBankById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query('banks', where: 'id = ?', whereArgs: [id]);
    return maps.isEmpty ? null : BankModel.fromMap(maps.first);
  }

  Future<void> updateBank(BankModel bank) async {
    final db = await _dbHelper.database;
    bank.updatedAt = DateTime.now();
    await db.update(
      'banks',
      bank.toMap(),
      where: 'id = ?',
      whereArgs: [bank.id],
    );
  }

  Future<void> deleteBank(int id) async {
    final db = await _dbHelper.database;
    await db.delete('banks', where: 'id = ?', whereArgs: [id]);
  }
}
