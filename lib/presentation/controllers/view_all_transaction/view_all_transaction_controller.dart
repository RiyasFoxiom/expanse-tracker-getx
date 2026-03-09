import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/presentation/widgets/app_dialogs.dart';
import 'package:intl/intl.dart';
import 'package:test_app/data/models/transaction_model.dart';
import 'package:test_app/data/repositories/transaction_repository.dart';

class ViewAllTransactionController extends GetxController {
  final TransactionRepository _repository = Get.find<TransactionRepository>();

  final RxList<TransactionModel> allTransactions = <TransactionModel>[].obs;
  final RxList<TransactionModel> filteredTransactions =
      <TransactionModel>[].obs;
  final RxMap<String, List<TransactionModel>> groupedTransactions =
      <String, List<TransactionModel>>{}.obs;

  // All-time totals (unchanged)
  final RxDouble totalIncome = 0.0.obs;
  final RxDouble totalExpense = 0.0.obs;
  final RxDouble totalBalance = 0.0.obs;

  // Filter & Sort State
  final RxString selectedType = 'all'.obs; // 'all', 'income', 'expense'
  final RxString selectedSort =
      'newest'.obs; // 'newest', 'oldest', 'highest', 'lowest'
  final RxString selectedCategory = 'all'.obs;

  // Unique categories for dropdown
  final RxList<String> categories = <String>[].obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    fetchTransactions();
    super.onInit();
  }

  Future<void> fetchTransactions() async {
    try {
      isLoading.value = true;
      final result = await _repository.getAllTransactions();

      result.sort((a, b) => b.date.compareTo(a.date)); // Default newest
      allTransactions.assignAll(result);

      // Extract unique categories
      final Set<String> uniqueCats = result.map((tx) => tx.category).toSet();
      categories.assignAll(['all', ...uniqueCats.toList()..sort()]);

      applyFiltersAndSort();
    } catch (e) {
      debugPrint('Error: $e');
      AppDialogs.showSnackbar(
        message: 'Failed to load transactions',
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void applyFiltersAndSort() {
    List<TransactionModel> filtered = List.from(allTransactions);

    // Filter by type
    if (selectedType.value != 'all') {
      filtered = filtered.where((tx) => tx.type == selectedType.value).toList();
    }

    // Filter by category
    if (selectedCategory.value != 'all') {
      filtered = filtered
          .where((tx) => tx.category == selectedCategory.value)
          .toList();
    }

    // Sort
    switch (selectedSort.value) {
      case 'newest':
        filtered.sort((a, b) => b.date.compareTo(a.date));
        break;
      case 'oldest':
        filtered.sort((a, b) => a.date.compareTo(b.date));
        break;
      case 'highest':
        filtered.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case 'lowest':
        filtered.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }

    filteredTransactions.assignAll(filtered);
    calculateAllTimeTotals(); // Recalculate based on filtered
    groupTransactionsByDate();
  }

  void calculateAllTimeTotals() {
    double income = 0.0;
    double expense = 0.0;
    for (var tx in filteredTransactions) {
      if (tx.type == 'income') income += tx.amount;
      if (tx.type == 'expense') expense += tx.amount;
    }
    totalIncome.value = income;
    totalExpense.value = expense;
    totalBalance.value = income - expense;
  }

  void groupTransactionsByDate() {
    final Map<String, List<TransactionModel>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateFormat = DateFormat('dd MMM yyyy');

    for (var tx in filteredTransactions) {
      final txDate = DateTime(tx.date.year, tx.date.month, tx.date.day);
      String key = txDate == today
          ? 'Today'
          : txDate == yesterday
          ? 'Yesterday'
          : dateFormat.format(tx.date);

      grouped.putIfAbsent(key, () => []).add(tx);
    }

    final sortedKeys = grouped.keys.toList();
    sortedKeys.sort((a, b) {
      if (a == 'Today') return -1;
      if (b == 'Today') return 1;
      if (a == 'Yesterday') return -1;
      if (b == 'Yesterday') return 1;
      final dateA = DateFormat('dd MMM yyyy').parse(a);
      final dateB = DateFormat('dd MMM yyyy').parse(b);
      return dateB.compareTo(dateA);
    });

    final sortedGrouped = <String, List<TransactionModel>>{};
    for (var key in sortedKeys) {
      sortedGrouped[key] = grouped[key]!;
    }

    groupedTransactions.assignAll(sortedGrouped);
  }

  // Reset all filters
  void resetFilters() {
    selectedType.value = 'all';
    selectedSort.value = 'newest';
    selectedCategory.value = 'all';
    applyFiltersAndSort();
  }

  Future<void> deleteTransaction(int id) async {
    try {
      await _repository.deleteTransaction(id);
      await fetchTransactions(); // Refresh the list
      AppDialogs.showSnackbar(
        message: "Transaction deleted successfully",
        isSuccess: true,
      );
    } catch (e) {
      AppDialogs.showSnackbar(
        message: "Failed to delete transaction",
        isError: true,
      );
    }
  }
}
