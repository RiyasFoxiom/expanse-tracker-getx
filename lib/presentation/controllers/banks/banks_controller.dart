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

  Future<void> updateBank(BankModel bank) async {
    try {
      await repo.addOrUpdateBank(bank);
      await loadBanks();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update bank');
    }
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

  Future<void> transferFunds(
    int fromBankId,
    int toBankId,
    double amount,
  ) async {
    if (fromBankId == toBankId) {
      Get.snackbar('Error', 'Cannot transfer to the same bank');
      return;
    }
    if (amount <= 0) {
      Get.snackbar('Error', 'Amount must be greater than zero');
      return;
    }
    try {
      await repo.transferFunds(fromBankId, toBankId, amount);
      await loadBanks();
      Get.back(); // Close the modal
      Get.snackbar('Success', 'Funds transferred successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
    }
  }
}
