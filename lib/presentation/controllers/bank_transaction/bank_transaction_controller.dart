import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_app/data/models/bank_model.dart';
import 'package:test_app/data/models/transaction_model.dart';
import 'package:test_app/data/repositories/transaction_repository.dart';
import 'package:test_app/presentation/widgets/app_dialogs.dart';

class BankTransactionController extends GetxController {
  BankTransactionController({required this.bank});

  final BankModel bank;
  final TransactionRepository _repo = Get.find<TransactionRepository>();

  final RxList<TransactionModel> allTransactions = <TransactionModel>[].obs;
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  final RxBool isLoading = false.obs;

  final RxString selectedType = 'all'.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxDouble totalIncome = 0.0.obs;
  final RxDouble totalExpense = 0.0.obs;
  final RxDouble totalValue = 0.0.obs;

  String get dateLabel => selectedDate.value == null
      ? 'ALL DATES'
      : DateFormat('dd MMM yyyy').format(selectedDate.value!).toUpperCase();

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
      result.sort((a, b) {
        final byDate = b.date.compareTo(a.date);
        if (byDate != 0) return byDate;
        return b.createdAt.compareTo(a.createdAt);
      });
      allTransactions.assignAll(result);
      applyFilters();
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

  void applyFilters() {
    var filtered = List<TransactionModel>.from(allTransactions);

    if (selectedType.value != 'all') {
      filtered = filtered.where((tx) => tx.type == selectedType.value).toList();
    }

    final date = selectedDate.value;
    if (date != null) {
      final start = DateTime(date.year, date.month, date.day);
      final end = start.add(const Duration(days: 1));
      filtered = filtered
          .where((tx) => !tx.date.isBefore(start) && tx.date.isBefore(end))
          .toList();
    }

    transactions.assignAll(filtered);
    totalIncome.value = filtered
        .where((tx) => tx.type == 'income')
        .fold(0.0, (sum, tx) => sum + tx.amount);
    totalExpense.value = filtered
        .where((tx) => tx.type == 'expense')
        .fold(0.0, (sum, tx) => sum + tx.amount);
    totalValue.value = filtered.fold(0.0, (sum, tx) => sum + tx.amount);
  }

  void updateType(String type) {
    selectedType.value = type;
    applyFilters();
  }

  void updateDate(DateTime? date) {
    selectedDate.value = date == null
        ? null
        : DateTime(date.year, date.month, date.day);
    applyFilters();
  }

  void clearFilters() {
    selectedType.value = 'all';
    selectedDate.value = null;
    applyFilters();
  }
}
