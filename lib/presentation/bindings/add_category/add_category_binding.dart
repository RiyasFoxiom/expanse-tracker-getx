import 'package:get/get.dart';
import 'package:test_app/presentation/controllers/add_category/add_category_controller.dart';

class AddCategoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddCategoryController(), fenix: true);
  }
}
