import 'package:get/get.dart';
import 'package:test_app/data/datasources/transaction_local_datasource.dart';
import 'package:test_app/data/repositories/transaction_repository.dart';
import 'package:test_app/presentation/controllers/view_all_transaction/view_all_transaction_controller.dart';

class ViewAllTransactionBinding implements Bindings {
  @override
  void dependencies() {
    
    if (!Get.isRegistered<TransactionRepository>()) {
      Get.lazyPut<TransactionLocalDataSource>(
        () => TransactionLocalDataSource(),
      );
      Get.lazyPut<TransactionRepository>(
        () => TransactionRepository(Get.find<TransactionLocalDataSource>()),
      );
    }

    Get.lazyPut<ViewAllTransactionController>(
      () => ViewAllTransactionController(),
    );
  }
}
