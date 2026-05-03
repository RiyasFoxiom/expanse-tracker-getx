import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_app/data/models/transaction_model.dart';
import 'package:test_app/data/repositories/transaction_repository.dart';
import 'package:test_app/presentation/widgets/app_dialogs.dart';

class TransactionTableController extends GetxController {
  TransactionTableController({this.categoryName});

  final String? categoryName;
  final TransactionRepository _repository = Get.find<TransactionRepository>();

  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  final Rx<DateTime> selectedMonth = DateTime.now().obs;
  final RxBool isLoading = false.obs;
  final RxDouble totalAmount = 0.0.obs;
  final RxDouble totalIncome = 0.0.obs;
  final RxDouble totalExpense = 0.0.obs;
  final RxInt transactionCount = 0.obs;

  bool get isCategoryMode => categoryName != null && categoryName!.isNotEmpty;

  String get formattedMonth =>
      DateFormat('MMMM yyyy').format(selectedMonth.value);

  String get pageTitle => isCategoryMode
      ? '${categoryName!.toUpperCase()} TRANSACTIONS'
      : 'ALL TRANSACTIONS';

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    try {
      isLoading.value = true;

      final allTransactions = await _repository.getAllTransactions();
      final month = selectedMonth.value;
      final start = DateTime(month.year, month.month, 1);
      final end = DateTime(month.year, month.month + 1, 1);

      final filtered =
          allTransactions.where((tx) {
            final matchesMonth =
                !tx.date.isBefore(start) && tx.date.isBefore(end);
            final matchesCategory =
                !isCategoryMode || tx.category == categoryName;
            return matchesMonth && matchesCategory;
          }).toList()..sort((a, b) {
            final byDate = b.date.compareTo(a.date);
            if (byDate != 0) return byDate;
            return b.createdAt.compareTo(a.createdAt);
          });

      transactions.assignAll(filtered);
      transactionCount.value = filtered.length;
      totalAmount.value = filtered.fold(0.0, (sum, tx) => sum + tx.amount);
      totalIncome.value = filtered
          .where((tx) => tx.type == 'income')
          .fold(0.0, (sum, tx) => sum + tx.amount);
      totalExpense.value = filtered
          .where((tx) => tx.type == 'expense')
          .fold(0.0, (sum, tx) => sum + tx.amount);
    } catch (e) {
      debugPrint('Error loading transaction table: $e');
      AppDialogs.showSnackbar(
        message: 'Failed to load transactions',
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateMonth(DateTime month) async {
    selectedMonth.value = DateTime(month.year, month.month, 1);
    await loadTransactions();
  }
}
