import 'package:get/get.dart';
import 'package:test_app/presentation/controllers/categories/categories_controller.dart';

class CategoriesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategoriesController());
  }
}