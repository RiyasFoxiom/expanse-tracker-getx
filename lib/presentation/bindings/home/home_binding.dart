import 'package:get/get.dart';
import 'package:test_app/data/datasources/transaction_local_datasource.dart';
import 'package:test_app/data/repositories/transaction_repository.dart';
import 'package:test_app/presentation/controllers/home/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // Register datasources
    Get.lazyPut<TransactionLocalDataSource>(() => TransactionLocalDataSource());

    Get.lazyPut<TransactionRepository>(
      () => TransactionRepository(Get.find<TransactionLocalDataSource>()),
    );

    Get.lazyPut<HomeController>(() => HomeController());
  }
}
