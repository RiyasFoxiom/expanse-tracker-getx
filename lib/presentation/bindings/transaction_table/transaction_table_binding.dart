import 'package:get/get.dart';
import 'package:test_app/presentation/controllers/transaction_table/transaction_table_controller.dart';

class TransactionTableBinding implements Bindings {
  TransactionTableBinding({this.categoryName});

  final String? categoryName;

  @override
  void dependencies() {
    Get.lazyPut<TransactionTableController>(
      () => TransactionTableController(categoryName: categoryName),
    );
  }
}
