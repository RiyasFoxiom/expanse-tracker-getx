import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_app/data/models/transaction_model.dart';
import 'package:test_app/data/repositories/bank_repository.dart';
import 'package:test_app/data/repositories/transaction_repository.dart';
import 'package:test_app/presentation/controllers/banks/banks_controller.dart';
import 'package:test_app/presentation/controllers/home/home_controller.dart';
import 'package:test_app/presentation/widgets/app_dialogs.dart';

class TransactionsController extends GetxController {
  final TransactionRepository _repository = Get.find<TransactionRepository>();

  final RxList<TransactionModel> allTransactions = <TransactionModel>[].obs;
  final RxList<TransactionModel> filteredTransactions =
      <TransactionModel>[].obs;
  final RxMap<String, List<TransactionModel>> groupedTransactions =
      <String, List<TransactionModel>>{}.obs;

  // Totals for the current filtered list
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

      result.sort((a, b) {
        int cmp = b.date.compareTo(a.date);
        if (cmp != 0) return cmp;
        return b.createdAt.compareTo(a.createdAt);
      }); // Default newest, then by creation time
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
        filtered.sort((a, b) {
          int cmp = b.date.compareTo(a.date);
          if (cmp != 0) return cmp;
          return b.createdAt.compareTo(a.createdAt);
        });
        break;
      case 'oldest':
        filtered.sort((a, b) {
          int cmp = a.date.compareTo(b.date);
          if (cmp != 0) return cmp;
          return a.createdAt.compareTo(b.createdAt);
        });
        break;
      case 'highest':
        filtered.sort((a, b) {
          int cmp = b.amount.compareTo(a.amount);
          if (cmp != 0) return cmp;
          return b.createdAt.compareTo(a.createdAt);
        });
        break;
      case 'lowest':
        filtered.sort((a, b) {
          int cmp = a.amount.compareTo(b.amount);
          if (cmp != 0) return cmp;
          return b.createdAt.compareTo(a.createdAt);
        });
        break;
    }

    filteredTransactions.assignAll(filtered);
    calculateTotals();
    groupTransactionsByDate();
  }

  void calculateTotals() {
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

  Future<void> completePayback(TransactionModel tx) async {
    try {
      isLoading.value = true;

      // Update original transaction as completed
      tx.isCompleted = true;
      await _repository.updateTransaction(tx);

      // Create a NEW INCOME transaction for the payback
      final paybackIncome = TransactionModel(
        amount: tx.amount,
        type: 'income',
        category: "PAYBACK",
        date: DateTime.now(),
        notes: "RETURN FOR: ${tx.category.toUpperCase()} | ${tx.notes ?? ''}",
        bankId: tx.bankId,
        isPayback: false,
        isCompleted: true,
      );

      await _repository.addTransaction(paybackIncome);

      // Update bank balance (Income adds money)
      if (tx.bankId != null) {
        final bankRepo = Get.find<BankRepository>();
        final freshBank = await bankRepo.getBankById(tx.bankId!);
        if (freshBank != null) {
          double newBalance = freshBank.balance + tx.amount;
          await bankRepo.updateBankBalance(freshBank.id!, newBalance);

          if (Get.isRegistered<BanksController>()) {
            Get.find<BanksController>().loadBanks();
          }
        }
      }

      await fetchTransactions(); // Refresh the list

      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().getAllTransactions();
      }
      AppDialogs.showSnackbar(
        message: "Payback completed and Income added!",
        isSuccess: true,
      );
    } catch (e) {
      debugPrint("Payback error: $e");
      AppDialogs.showSnackbar(
        message: "Failed to complete payback",
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
