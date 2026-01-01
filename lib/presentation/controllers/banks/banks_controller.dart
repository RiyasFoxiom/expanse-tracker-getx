import 'package:get/get.dart';
import 'package:test_app/data/models/bank_model.dart';
import 'package:test_app/data/repositories/bank_repository.dart';

class BanksController extends GetxController {
  final BankRepository repo = Get.find();
  final RxList<BankModel> banks = <BankModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadBanks();
  }

  Future<void> loadBanks() async {
    isLoading.value = true;
    banks.value = await repo.getAllBanks();
    isLoading.value = false;
  }

  Future<void> deleteBank(int id) async {
    try {
      await repo.deleteBank(id);
      await loadBanks();
      Get.snackbar('Success', 'Bank deleted');
    } catch (e) {
      Get.snackbar('Error', 'Cannot delete bank with transactions');
    }
  }
}
