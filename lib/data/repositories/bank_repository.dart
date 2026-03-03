// data/repositories/bank_repository.dart
import 'package:get/get.dart';
import 'package:test_app/data/datasources/bank_local_datasource.dart';
import 'package:test_app/data/models/bank_model.dart';
import 'package:test_app/data/repositories/transaction_repository.dart';

class BankRepository {
  final BankLocalDataSource _local;

  BankRepository(this._local);

  Future<List<BankModel>> getAllBanks() => _local.getAllBanks();
  Future<void> addBank(BankModel bank) => _local.addBank(bank);
  Future<void> updateBank(BankModel bank) => _local.updateBank(bank);

  Future<void> addOrUpdateBank(BankModel bank) async {
    if (bank.id == null || bank.id == 0) {
      await _local.addBank(bank);
    } else {
      await _local.updateBank(bank);
    }
  }

  Future<void> updateBankBalance(int id, double newBalance) =>
      _local.updateBankBalance(id, newBalance);
  Future<BankModel?> getBankById(int id) => _local.getBankById(id);
  Future<void> deleteBank(int id) async => await _local.deleteBank(id);

  Future<bool> hasTransactions(int bankId) async {
    final txRepo = Get.find<TransactionRepository>();
    final transactions = await txRepo.getAllTransactions();
    return transactions.any((tx) => tx.bankId == bankId);
  }

  Future<void> transferFunds(int fromBankId, int toBankId, double amount) =>
      _local.transferFunds(fromBankId, toBankId, amount);
}
