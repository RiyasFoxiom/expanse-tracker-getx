import 'package:get/get.dart';
import 'package:test_app/data/datasources/bank_local_datasource.dart';
import 'package:test_app/data/repositories/bank_repository.dart';
import 'package:test_app/presentation/controllers/banks/banks_controller.dart';

class BanksBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BankLocalDataSource>(() => BankLocalDataSource());
    Get.lazyPut<BankRepository>(() => BankRepository(Get.find()));
    Get.lazyPut<BanksController>(() => BanksController());
  }
}
