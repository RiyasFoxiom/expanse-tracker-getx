import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/presentation/widgets/app_dialogs.dart';
import 'package:intl/intl.dart';
import 'package:test_app/data/models/transaction_model.dart';
import 'package:test_app/data/repositories/transaction_repository.dart';

class HomeController extends GetxController {
  late TransactionRepository _transactionRepository;

  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  final RxList<TransactionModel> filteredTransactions =
      <TransactionModel>[].obs;
  final RxList<TransactionModel> listTransactions = <TransactionModel>[].obs;

  final RxBool isLoading = false.obs;

  // Dashboard totals (month-based)
  final RxDouble totalIncome = 0.0.obs;
  final RxDouble totalExpense = 0.0.obs;
  final RxDouble totalBalance = 0.0.obs;

  // Selected month for dashboard
  final Rx<DateTime> selectedMonth = DateTime.now().obs;

  // Selected filter tab
  final RxString selectedTab = 'today'.obs;

  @override
  void onInit() {
    _transactionRepository = Get.find<TransactionRepository>();

    getAllTransactions();
    super.onInit();
  }

  @override
  void onClose() {
    // tabController.dispose();
    super.onClose();
  }

  Future<void> getAllTransactions() async {
    try {
      isLoading.value = true;
      final result = await _transactionRepository.getAllTransactions();
      transactions.assignAll(result);
      transactions.sort((a, b) => b.date.compareTo(a.date));
      filterTransactionsByMonth();
    } catch (e) {
      debugPrint('Error fetching transactions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterTransactionsByMonth() {
    final startOfMonth = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month,
      1,
    );
    final endOfMonth = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month + 1,
      1,
    );

    filteredTransactions.assignAll(
      transactions
          .where(
            (tx) =>
                tx.date.isAfter(
                  startOfMonth.subtract(const Duration(seconds: 1)),
                ) &&
                tx.date.isBefore(endOfMonth),
          )
          .toList(),
    );
    calculateTotals();
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

  // void updateList

  String get formattedMonth =>
      DateFormat('MMMM yyyy').format(selectedMonth.value);

  void selectMonth(DateTime newMonth) {
    selectedMonth.value = DateTime(newMonth.year, newMonth.month);
    filterTransactionsByMonth();
  }

  // For pie chart sections (reactive)
  List<PieChartSectionData> get pieChartSections {
    final income = totalIncome.value;
    final expense = totalExpense.value;
    final total = income + expense;

    if (total == 0) {
      return [
        PieChartSectionData(
          value: 1,
          color: Colors.grey[300],
          radius: 50,
          showTitle: false,
        ),
      ];
    }

    return [
      PieChartSectionData(
        value: income,
        color: const Color(0xff4CAF50), // Green for income
        title: '${((income / total) * 100).toStringAsFixed(2)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: expense,
        color: const Color(0xffF44336), // Red for expense
        title: '${((expense / total) * 100).toStringAsFixed(2)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  // Optional: Center text showing total or balance
  String get centerChartText =>
      "Balance\n₹${totalBalance.value.toStringAsFixed(2)}";

  /// Returns a list of daily totals for the last 7 days.
  /// Each item in the list is a Map containing 'date', 'income', and 'expense'.
  List<Map<String, dynamic>> getLast7DaysData() {
    final now = DateTime.now();
    final List<Map<String, dynamic>> data = [];

    // Loop backwards over the last 7 days (including today)
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));

      double dailyIncome = 0;
      double dailyExpense = 0;

      for (var tx in transactions) {
        if (tx.date.year == date.year &&
            tx.date.month == date.month &&
            tx.date.day == date.day) {
          if (tx.type == 'income') {
            dailyIncome += tx.amount;
          } else if (tx.type == 'expense') {
            dailyExpense += tx.amount;
          }
        }
      }

      data.add({
        'date': date,
        'label': DateFormat('EEE').format(date), // e.g., 'Mon', 'Tue'
        'income': dailyIncome,
        'expense': dailyExpense,
      });
    }

    return data;
  }

  Future<void> deleteTransaction(int id) async {
    try {
      await _transactionRepository.deleteTransaction(id);
      await getAllTransactions();
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
