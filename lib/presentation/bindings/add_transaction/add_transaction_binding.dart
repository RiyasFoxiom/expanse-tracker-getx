import 'package:get/get.dart';
import 'package:test_app/data/datasources/bank_local_datasource.dart';
import 'package:test_app/data/datasources/category_local_datasource.dart';
import 'package:test_app/data/datasources/transaction_local_datasource.dart';
import 'package:test_app/data/repositories/bank_repository.dart';
import 'package:test_app/data/repositories/category_repository.dart';
import 'package:test_app/data/repositories/transaction_repository.dart';
import 'package:test_app/presentation/controllers/add_transaction/add_transaction_controller.dart';
import 'package:test_app/presentation/controllers/home/home_controller.dart';

class AddTransactionBinding implements Bindings {
  @override
  void dependencies() {
    // Register datasources
    Get.lazyPut<CategoryLocalDataSource>(() => CategoryLocalDataSource());
    Get.lazyPut<TransactionLocalDataSource>(() => TransactionLocalDataSource());
    Get.lazyPut<BankLocalDataSource>(() => BankLocalDataSource());

    // Register repositories
    Get.lazyPut<CategoryRepository>(
      () => CategoryRepository(Get.find<CategoryLocalDataSource>()),
    );
    Get.lazyPut<TransactionRepository>(
      () => TransactionRepository(Get.find<TransactionLocalDataSource>()),
    );
    Get.lazyPut<BankRepository>(
      () => BankRepository(Get.find<BankLocalDataSource>()),
    );

    // Register controller
    Get.lazyPut<AddTransactionController>(() => AddTransactionController());

    Get.lazyPut<HomeController>(() => HomeController());
  }
}
