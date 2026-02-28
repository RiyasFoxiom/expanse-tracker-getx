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

  Future<void> transferFunds(
    int fromBankId,
    int toBankId,
    double amount,
  ) async {
    final db = await _dbHelper.database;
    await db.transaction((txn) async {
      // Fetch source bank
      final fromMapped = await txn.query(
        'banks',
        where: 'id = ?',
        whereArgs: [fromBankId],
      );
      if (fromMapped.isEmpty) throw Exception('Source bank not found');
      double fromBalance = fromMapped.first['balance'] as double;
      if (fromBalance < amount) throw Exception('Insufficient balance');

      // Update source bank balance
      await txn.update(
        'banks',
        {
          'balance': fromBalance - amount,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [fromBankId],
      );

      // Fetch destination bank
      final toMapped = await txn.query(
        'banks',
        where: 'id = ?',
        whereArgs: [toBankId],
      );
      if (toMapped.isEmpty) throw Exception('Destination bank not found');
      double toBalance = toMapped.first['balance'] as double;

      // Update destination bank balance
      await txn.update(
        'banks',
        {
          'balance': toBalance + amount,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [toBankId],
      );

      final String now = DateTime.now().toIso8601String();

      // Insert transfer out transaction for source bank
      await txn.insert('transactions', {
        'amount': amount,
        'category': 'Transfer',
        'type': 'expense',
        'date': now,
        'notes': 'Transfer Out',
        'created_at': now,
        'bank_id': fromBankId,
      });

      // Insert transfer in transaction for destination bank
      await txn.insert('transactions', {
        'amount': amount,
        'category': 'Transfer',
        'type': 'income',
        'date': now,
        'notes': 'Transfer In',
        'created_at': now,
        'bank_id': toBankId,
      });
    });
  }
}
