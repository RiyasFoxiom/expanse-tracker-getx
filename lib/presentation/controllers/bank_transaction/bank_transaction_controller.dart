import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/presentation/widgets/app_dialogs.dart';
import 'package:test_app/data/models/bank_model.dart';
import 'package:test_app/data/models/transaction_model.dart';
import 'package:test_app/data/repositories/transaction_repository.dart';

class BankTransactionController extends GetxController {
  final BankModel bank;

  BankTransactionController({required this.bank});

  final TransactionRepository _repo = Get.find<TransactionRepository>();

  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    loadTransactions();
  }

  Future<void> loadTransactions() async {
    if (bank.id == null) return;

    try {
      isLoading.value = true;
      final result = await _repo.getTransactionsByBank(bank.id!);
      result.sort((a, b) => b.date.compareTo(a.date));
      transactions.assignAll(result);
    } catch (e) {
      AppDialogs.showSnackbar(
        message: 'Failed to load transactions',
        isError: true,
      );
      debugPrint('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
