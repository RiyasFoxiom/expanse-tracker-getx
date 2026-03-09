import 'package:get/get.dart';
import 'package:test_app/data/models/bank_model.dart';
import 'package:test_app/data/repositories/bank_repository.dart';
import 'package:test_app/presentation/widgets/app_dialogs.dart';

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
      AppDialogs.showSnackbar(message: 'Failed to update bank', isError: true);
    }
  }

  Future<void> deleteBank(int id) async {
    try {
      await repo.deleteBank(id);
      await loadBanks();
      AppDialogs.showSnackbar(message: 'Bank deleted', isSuccess: true);
    } catch (e) {
      AppDialogs.showSnackbar(
        message: 'Cannot delete bank with transactions',
        isError: true,
      );
    }
  }

  Future<void> transferFunds(
    int fromBankId,
    int toBankId,
    double amount,
  ) async {
    if (fromBankId == toBankId) {
      AppDialogs.showSnackbar(
        message: 'Cannot transfer to the same bank',
        isError: true,
      );
      return;
    }
    if (amount <= 0) {
      AppDialogs.showSnackbar(
        message: 'Amount must be greater than zero',
        isError: true,
      );
      return;
    }
    try {
      await repo.transferFunds(fromBankId, toBankId, amount);
      await loadBanks();
      Get.back(); // Close the modal
      AppDialogs.showSnackbar(
        message: 'Funds transferred successfully',
        isSuccess: true,
      );
    } catch (e) {
      AppDialogs.showSnackbar(
        message: e.toString().replaceAll('Exception: ', ''),
        isError: true,
      );
    }
  }
}
