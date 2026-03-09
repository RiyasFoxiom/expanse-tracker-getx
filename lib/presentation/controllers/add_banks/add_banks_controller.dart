import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/data/models/bank_model.dart';
import 'package:test_app/data/repositories/bank_repository.dart';
import 'package:test_app/presentation/controllers/banks/banks_controller.dart';
import 'package:test_app/presentation/widgets/app_dialogs.dart';

class AddBanksController extends GetxController {
  final BankRepository _bankRepo = Get.find<BankRepository>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();

  final RxString selectedType = 'savings'.obs;
  final RxBool isSaving = false.obs;

  final RxBool isEditing = false.obs;
  Rx<BankModel?> editingBank = Rx<BankModel?>(null);

  Future<void> saveBank() async {
    final name = nameController.text.trim();
    final last4Digits = cardNumberController.text.trim();
    final balanceStr = balanceController.text.trim();

    if (name.isEmpty) {
      AppDialogs.showSnackbar(
        message: 'Account name is required',
        isError: true,
      );
      return;
    }

    final balance = double.tryParse(balanceStr) ?? 0.0;

    // Format card number: **** **** **** 1234
    final formattedCardNumber = last4Digits.isEmpty
        ? '**** **** **** ****'
        : '**** **** **** $last4Digits';

    isSaving.value = true;

    final bank = BankModel(
      id: isEditing.value ? editingBank.value?.id : null,
      name: name,
      type: selectedType.value,
      cardNumber: formattedCardNumber,
      balance: balance,
      createdAt: isEditing.value ? editingBank.value?.createdAt : null,
    );

    try {
      if (isEditing.value) {
        await _bankRepo.updateBank(bank);
        Get.back();
        AppDialogs.showSnackbar(
          message: '$name updated successfully!',
          isSuccess: true,
        );
      } else {
        await _bankRepo.addBank(bank);
        Get.back();
        AppDialogs.showSnackbar(
          message: '$name added successfully!',
          isSuccess: true,
        );
      }

      if (Get.isRegistered<BanksController>()) {
        Get.find<BanksController>().loadBanks();
      }
    } catch (e) {
      debugPrint("error $e");
      AppDialogs.showSnackbar(
        message: isEditing.value
            ? 'Failed to update bank'
            : 'Failed to save bank',
        isError: true,
      );
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    cardNumberController.dispose();
    balanceController.dispose();
    super.onClose();
  }

  void setupForEdit(BankModel bank) {
    editingBank.value = bank;
    isEditing.value = true;

    nameController.text = bank.name;
    selectedType.value = bank.type;
    balanceController.text = bank.balance.toStringAsFixed(2);

    // Extract last 4 digits from **** **** **** 1234
    final parts = bank.cardNumber.split(' ');
    final last4 = parts.length >= 4 ? parts.last.replaceAll('*', '') : '';
    cardNumberController.text = last4 == '****' ? '' : last4;
  }

  void resetForAdd() {
    editingBank.value = null;
    isEditing.value = false;
    nameController.clear();
    cardNumberController.clear();
    balanceController.clear();
    selectedType.value = 'savings';
  }
}
