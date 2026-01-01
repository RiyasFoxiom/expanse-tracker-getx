import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/presentation/controllers/categories_chart/categories_chart_controller.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

class CategoriesChartView extends GetView<CategoriesChartController> {
  const CategoriesChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          "Category Breakdown",
          size: 22,
          weight: FontWeight.bold,
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Income Chart
              _buildChartCard(
                context: context,
                title: "Income by Category",
                total: controller.totalIncome.value,
                sections: controller.incomePieSections,
                legendEntries: controller.incomeCategoryTotals.entries,
                noDataText: "No income this month",
                isIncome: true,
              ),
              40.hBox,

              // Expense Chart
              _buildChartCard(
                context: context,
                title: "Expense by Category",
                total: controller.totalExpense.value,
                sections: controller.expensePieSections,
                legendEntries: controller.expenseCategoryTotals.entries,
                noDataText: "No expenses this month",
                isIncome: false,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildChartCard({
    required BuildContext context,
    required String title,
    required double total,
    required List<PieChartSectionData> sections,
    required Iterable<MapEntry<String, double>> legendEntries,
    required String noDataText,
    required bool isIncome,
  }) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = Get.isDarkMode;

    final hasData = total > 0;
    final cardColor = theme.cardColor;
    final primaryAccent = isIncome ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          AppText(
            title,
            size: 21,
            weight: FontWeight.bold,
            color: textTheme.titleLarge?.color,
          ),
          32.hBox,

          SizedBox(
            height: 280,
            child: hasData
                ? PieChart(
                    PieChartData(
                      sectionsSpace: 6,
                      centerSpaceRadius: 90,
                      sections: sections,
                      pieTouchData: PieTouchData(enabled: false),
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isIncome ? Icons.trending_up : Icons.trending_down,
                          size: 60,
                          color: colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                        16.hBox,
                        AppText(
                          noDataText,
                          size: 17,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ],
                    ),
                  ),
          ),

          if (hasData) ...[
            32.hBox,
            AppText(
              "₹${total.toStringAsFixed(0)}",
              size: 34,
              weight: FontWeight.bold,
              color: primaryAccent,
            ),
            32.hBox,
          ],

          // Legend
          if (hasData)
            Wrap(
              spacing: 24,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: legendEntries.map((entry) {
                final categoryColor = controller.getColor(entry.key);
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: categoryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? Colors.white24 : Colors.black12,
                          width: 1,
                        ),
                      ),
                    ),
                    12.wBox,
                    AppText(
                      entry.key,
                      size: 16,
                      weight: FontWeight.w600,
                      color: textTheme.bodyLarge?.color,
                    ),
                    12.wBox,
                    AppText(
                      "₹${entry.value.toStringAsFixed(0)}",
                      size: 16,
                      weight: FontWeight.bold,
                      color: categoryColor,
                    ),
                  ],
                );
              }).toList(),
            ),

          if (!hasData) 40.hBox,
        ],
      ),
    );
  }
}
