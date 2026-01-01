import 'package:get/get.dart';
import 'package:test_app/data/datasources/bank_local_datasource.dart';
import 'package:test_app/data/repositories/bank_repository.dart';
import 'package:test_app/presentation/controllers/add_banks/add_banks_controller.dart';

class AddBanksBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BankLocalDataSource>(() => BankLocalDataSource());
    Get.lazyPut<BankRepository>(() => BankRepository(Get.find()));
    Get.lazyPut<AddBanksController>(() => AddBanksController());
  }
}
