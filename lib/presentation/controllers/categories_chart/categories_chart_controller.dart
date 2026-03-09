import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/presentation/widgets/app_dialogs.dart';
import 'package:test_app/data/models/category_model.dart';
import 'package:test_app/data/repositories/category_repository.dart';
import 'package:test_app/data/repositories/transaction_repository.dart';

class CategoriesChartController extends GetxController {
  late CategoryRepository _categoryRepo;
  late TransactionRepository _transactionRepo;

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;

  // Income categories → total amount
  final RxMap<String, double> incomeCategoryTotals = <String, double>{}.obs;
  final RxDouble totalIncome = 0.0.obs;

  // Expense categories → total amount
  final RxMap<String, double> expenseCategoryTotals = <String, double>{}.obs;
  final RxDouble totalExpense = 0.0.obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _categoryRepo = Get.find<CategoryRepository>();
    _transactionRepo = Get.find<TransactionRepository>();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;

      // Load categories
      final cats = await _categoryRepo.getAllCategories();
      categories.assignAll(cats);

      // Load transactions
      final transactions = await _transactionRepo.getAllTransactions();

      // Current month filter
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, 1);
      final end = DateTime(now.year, now.month + 1, 1);

      final monthTx = transactions.where((tx) {
        return tx.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
            tx.date.isBefore(end);
      }).toList();

      // Reset
      incomeCategoryTotals.clear();
      expenseCategoryTotals.clear();
      totalIncome.value = 0.0;
      totalExpense.value = 0.0;

      // Calculate totals per category
      for (var tx in monthTx) {
        final cat = cats.firstWhereOrNull((c) => c.name == tx.category);
        if (cat != null) {
          if (tx.type == 'income') {
            incomeCategoryTotals[cat.name] =
                (incomeCategoryTotals[cat.name] ?? 0) + tx.amount;
            totalIncome.value += tx.amount;
          } else if (tx.type == 'expense') {
            expenseCategoryTotals[cat.name] =
                (expenseCategoryTotals[cat.name] ?? 0) + tx.amount;
            totalExpense.value += tx.amount;
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading chart data: $e');
      AppDialogs.showSnackbar(message: 'Failed to load chart', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // Income Pie Sections
  List<PieChartSectionData> get incomePieSections {
    if (totalIncome.value == 0) {
      return [noDataSection];
    }
    return incomeCategoryTotals.entries.map((entry) {
      final percentage = (entry.value / totalIncome.value) * 100;
      return PieChartSectionData(
        color: getColor(entry.key),
        value: entry.value,
        title: '${percentage.toStringAsFixed(2)}%',
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  // Expense Pie Sections
  List<PieChartSectionData> get expensePieSections {
    if (totalExpense.value == 0) {
      return [noDataSection];
    }
    return expenseCategoryTotals.entries.map((entry) {
      final percentage = (entry.value / totalExpense.value) * 100;
      return PieChartSectionData(
        color: getColor(entry.key),
        value: entry.value,
        title: '${percentage.toStringAsFixed(2)}%',
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  PieChartSectionData get noDataSection => PieChartSectionData(
    value: 1,
    color: Colors.grey[300],
    radius: 70,
    showTitle: false,
  );

  Color getColor(String categoryName) {
    const colors = [
      Colors.green,
      Colors.teal,
      Colors.cyan,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.pink,
      Colors.red,
      Colors.orange,
      Colors.amber,
    ];
    return colors[categoryName.hashCode.abs() % colors.length];
  }
}
