import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/core/helpers/screen_helper.dart';
import 'package:test_app/data/models/transaction_model.dart';
import 'package:test_app/presentation/bindings/add_transaction/add_transaction_binding.dart';
import 'package:test_app/presentation/bindings/view_all_transaction/view_all_transaction_binding.dart';
import 'package:test_app/presentation/controllers/home/home_controller.dart';
import 'package:test_app/presentation/pages/add_transaction/add_transaction_view.dart';
import 'package:test_app/presentation/pages/view_transaction/view_all_transaction_view.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final isDark = Get.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const AppText("Expense Tracker", size: 22),
        actions: [
          Obx(
            () => TextButton(
              onPressed: () => _showMonthYearPicker(context),
              child: Row(
                children: [
                  AppText(
                    controller.formattedMonth,
                    size: 16,
                    color:
                        theme.appBarTheme.titleTextStyle?.color ?? Colors.black,
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color:
                        theme.appBarTheme.titleTextStyle?.color ?? Colors.black,
                  ),
                ],
              ),
            ),
          ),
          16.wBox,
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          Screen.open(AddTransactionView(), binding: AddTransactionBinding());
        },
        child: const Icon(Icons.add),
      ),

      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: const [Color(0xff4facfe), Color(0xff00f2fe)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(
                          alpha: isDark ? 0.4 : 0.3,
                        ),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText(
                        "Total Balance",
                        color: Colors.white,
                        size: 14,
                      ),
                      8.hBox,
                      AppText(
                        "₹${controller.totalBalance.value.toStringAsFixed(0)}",
                        color: Colors.white,
                        size: 28,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ),
              16.hBox,
              Row(
                children: [
                  Obx(
                    () => _dashboardCard(
                      title: "Income",
                      amount:
                          "₹${controller.totalIncome.value.toStringAsFixed(0)}",
                      color: Colors.green,
                      icon: Icons.arrow_downward,
                    ),
                  ),
                  12.wBox,
                  Obx(
                    () => _dashboardCard(
                      title: "Expense",
                      amount:
                          "₹${controller.totalExpense.value.toStringAsFixed(0)}",
                      color: Colors.red,
                      icon: Icons.arrow_upward,
                    ),
                  ),
                ],
              ),

              30.hBox,

              // Income vs Expense Ring Chart
              Center(
                child: SizedBox(
                  height: 220,
                  width: 220,
                  child: Obx(
                    () => Stack(
                      children: [
                        PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(enabled: false),
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 4,
                            centerSpaceRadius: 70, // Makes it a ring/donut
                            sections: controller.pieChartSections,
                          ),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeInOutQuint,
                        ),
                        // Center Balance Text
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppText(
                                controller.centerChartText.split('\n')[0],
                                size: 14,
                                color: isDark
                                    ? Colors.white70
                                    : Colors.grey[700],
                              ),
                              AppText(
                                controller.centerChartText.split('\n')[1],
                                size: 24,
                                weight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              24.hBox,

              // Legend below chart
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _legendItem(color: const Color(0xff4CAF50), label: "Income"),
                  32.wBox,
                  _legendItem(color: const Color(0xffF44336), label: "Expense"),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppText(
                    "Recent Transactions",
                    size: 18,
                    weight: FontWeight.bold,
                  ),
                  TextButton(
                    onPressed: () {
                      Screen.open(
                        ViewAllTransactionView(),
                        binding: ViewAllTransactionBinding(),
                      );
                    },
                    child: const AppText("See All"),
                  ),
                ],
              ),
              12.hBox,

              Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CupertinoActivityIndicator());
                }

                if (controller.transactions.isEmpty) {
                  return Center(child: AppText("No transactions found."));
                }

                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.transactions.length > 5
                      ? 5
                      : controller.transactions.length,
                  separatorBuilder: (_, _) => 8.hBox,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final tx = controller.transactions[index];
                    return RepaintBoundary(
                      key: ValueKey('transaction_tile_${tx.id}'),
                      child: _transactionTile(tx, isDark),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _legendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        8.wBox,
        AppText(
          label,
          size: 14,
          color: Theme.of(Get.context!).textTheme.bodyMedium?.color,
        ),
      ],
    );
  }

  Widget _dashboardCard({
    required String title,
    required String amount,
    required Color color,
    required IconData icon,
    bool fullWidth = false,
  }) {
    final theme = Theme.of(Get.context!);
    return Expanded(
      flex: fullWidth ? 2 : 1,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // color: theme.cardColor,
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            8.hBox,
            AppText(title, style: const TextStyle(color: Colors.grey)),
            4.hBox,
            AppText(amount, color: color, size: 20, weight: FontWeight.bold),
          ],
        ),
      ),
    );
  }

  Widget _transactionTile(TransactionModel tx, bool isDark) {
    final incomeColor = Colors.green;
    final expenseColor = Colors.red;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: tx.type == 'income'
              ? incomeColor.withValues(alpha: 0.1)
              : expenseColor.withValues(alpha: 0.1),
          child: Icon(
            tx.type == 'income' ? Icons.arrow_downward : Icons.arrow_upward,
            color: tx.type == 'income' ? incomeColor : expenseColor,
          ),
        ),
        title: AppText(tx.category),
        subtitle: AppText(tx.date.toLocal().toString().split(' ')[0]),
        trailing: AppText(
          "${tx.type == 'income' ? '+' : '-'} ₹${tx.amount}",
          weight: FontWeight.bold,
          color: tx.type == 'income' ? incomeColor : expenseColor,
        ),
      ),
    );
  }

  void _showMonthYearPicker(BuildContext context) async {
    final controller = Get.find<HomeController>();

    // Reactive temporary values for live updates inside the dialog
    final RxInt tempYear = controller.selectedMonth.value.year.obs;
    final RxInt tempMonth = controller.selectedMonth.value.month.obs;

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const AppText('Select Month & Year'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Year Picker - Live update
                SizedBox(
                  height: 180,
                  child: Obx(
                    () => YearPicker(
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      selectedDate: DateTime(tempYear.value),
                      onChanged: (DateTime newYear) {
                        tempYear.value = newYear.year;
                      },
                    ),
                  ),
                ),
                24.hBox,

                Obx(
                  () => GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 2.2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: List.generate(12, (index) {
                      final month = index + 1;
                      // Highlight if this month matches the TEMP selected month and year
                      final isSelected =
                          month == tempMonth.value &&
                          tempYear.value == tempYear.value;

                      return GestureDetector(
                        onTap: () {
                          tempMonth.value = month;
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: AppText(
                            DateFormat('MMM').format(DateTime(2025, month)),
                            color: isSelected ? Colors.white : Colors.black87,
                            size: 15,
                            weight: FontWeight.w600,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const AppText('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.selectMonth(
                  DateTime(tempYear.value, tempMonth.value),
                );
                Navigator.pop(dialogContext);
              },
              child: const AppText(
                'OK',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
