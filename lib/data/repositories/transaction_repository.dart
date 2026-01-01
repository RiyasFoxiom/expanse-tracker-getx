import 'package:test_app/data/datasources/transaction_local_datasource.dart';
import 'package:test_app/data/models/transaction_model.dart';

class TransactionRepository {
  final TransactionLocalDataSource _localDataSource;

  TransactionRepository(this._localDataSource);

  Future<int> addTransaction(TransactionModel transaction) async {
    return await _localDataSource.addTransaction(transaction);
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    return await _localDataSource.getAllTransactions();
  }

  Future<List<TransactionModel>> getTransactionsByDate(DateTime date) async {
    return await _localDataSource.getTransactionsByDate(date);
  }

  Future<List<TransactionModel>> getTransactionsByCategory(
    String category,
  ) async {
    return await _localDataSource.getTransactionsByCategory(category);
  }

  Future<int> updateTransaction(TransactionModel transaction) async {
    return await _localDataSource.updateTransaction(transaction);
  }

  Future<List<TransactionModel>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    return await _localDataSource.getTransactionsByDateRange(start, end);
  }

  Future<List<TransactionModel>> getTransactionsByBank(int bankId) async {
    return await _localDataSource.getTransactionsByBank(bankId);
  }

  Future<int> deleteTransaction(int id) async {
    return await _localDataSource.deleteTransaction(id);
  }
}
