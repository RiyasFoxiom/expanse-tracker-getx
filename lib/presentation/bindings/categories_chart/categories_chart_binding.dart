import 'package:get/get.dart';
import 'package:test_app/data/datasources/category_local_datasource.dart';
import 'package:test_app/data/datasources/transaction_local_datasource.dart';
import 'package:test_app/data/repositories/category_repository.dart';
import 'package:test_app/data/repositories/transaction_repository.dart';
import 'package:test_app/presentation/controllers/categories_chart/categories_chart_controller.dart';

class CategoriesChartBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryLocalDataSource>(() => CategoryLocalDataSource());
    Get.lazyPut<TransactionLocalDataSource>(() => TransactionLocalDataSource());
    Get.lazyPut<CategoryRepository>(() => CategoryRepository(Get.find()));
    Get.lazyPut<TransactionRepository>(() => TransactionRepository(Get.find()));
    Get.lazyPut<CategoriesChartController>(() => CategoriesChartController());
  }
}
