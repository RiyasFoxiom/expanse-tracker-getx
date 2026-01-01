import 'package:get/get.dart';
import 'package:test_app/data/datasources/transaction_local_datasource.dart';
import 'package:test_app/data/models/bank_model.dart';
import 'package:test_app/data/repositories/transaction_repository.dart';
import 'package:test_app/presentation/controllers/bank_transaction/bank_transaction_controller.dart';

class BankTransactionBinding implements Bindings {
  final BankModel bank;

  BankTransactionBinding(this.bank);

  @override
  void dependencies() {
    Get.lazyPut<TransactionLocalDataSource>(() => TransactionLocalDataSource());
    Get.lazyPut<TransactionRepository>(() => TransactionRepository(Get.find()));

    Get.lazyPut<BankTransactionController>(
      () => BankTransactionController(bank: bank),
    );
  }
}
