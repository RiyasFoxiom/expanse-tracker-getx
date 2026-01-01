import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/data/models/bank_model.dart';
import 'package:test_app/data/repositories/bank_repository.dart';
import 'package:test_app/presentation/controllers/banks/banks_controller.dart';

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

    if (name.isEmpty || balanceStr.isEmpty) {
      Get.snackbar('Error', 'Please fill required fields');
      return;
    }

    final balance = double.tryParse(balanceStr) ?? 0.0;

    // Format card number: **** **** **** 1234
    final formattedCardNumber = last4Digits.isEmpty
        ? '**** **** **** ****'
        : '**** **** **** $last4Digits';

    isSaving.value = true;

    final bank = BankModel(
      name: name,
      type: selectedType.value,
      cardNumber: formattedCardNumber,
      balance: balance,
    );

    try {
      await _bankRepo.addBank(bank);
      Get.back();
      Get.snackbar('Success', '$name added successfully!');

      if (Get.isRegistered<BanksController>()) {
        Get.find<BanksController>().loadBanks();
      }
    } catch (e) {
      debugPrint("error $e");
      Get.snackbar('Error', 'Failed to save bank');
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
    balanceController.text = bank.balance.toStringAsFixed(0);

    // Extract last 4 digits from **** **** **** 1234
    final parts = bank.cardNumber.split(' ');
    final last4 = parts.length >= 4 ? parts.last.replaceAll('*', '') : '';
    cardNumberController.text = last4 == '****' ? '' : last4;
  }
}
