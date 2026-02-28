import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/presentation/controllers/categories_chart/categories_chart_controller.dart';

class CategoriesChartView extends GetView<CategoriesChartController> {
  const CategoriesChartView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Charts",
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CupertinoActivityIndicator(radius: 16));
        }

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              // Income Chart
              _buildChartCard(
                context: context,
                title: "Income by Category",
                total: controller.totalIncome.value,
                sections: controller.incomePieSections,
                legendEntries: controller.incomeCategoryTotals.entries,
                noDataText: "No recorded income",
                isIncome: true,
              ),
              const SizedBox(height: 32),

              // Expense Chart
              _buildChartCard(
                context: context,
                title: "Expense by Category",
                total: controller.totalExpense.value,
                sections: controller.expensePieSections,
                legendEntries: controller.expenseCategoryTotals.entries,
                noDataText: "No recorded expenses",
                isIncome: false,
              ),
              const SizedBox(height: 100),
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
    final isDark = Get.isDarkMode;

    final hasData = total > 0;
    final accentColor = isIncome
        ? const Color(0xFF34C759)
        : const Color(0xFFFF3B30);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 32),

          SizedBox(
            height: 240,
            child: hasData
                ? PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(enabled: false),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 4,
                      centerSpaceRadius: 85,
                      sections: sections,
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 600),
                    swapAnimationCurve: Curves.easeOutCubic,
                  )
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isIncome
                              ? CupertinoIcons.chart_bar_fill
                              : CupertinoIcons.chart_pie_fill,
                          size: 60,
                          color: Colors.grey.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          noDataText,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? Colors.white54
                                : Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),

          if (hasData) ...[
            const SizedBox(height: 40),
            Text(
              "Total",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white54 : Colors.grey.shade500,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "₹${total.toStringAsFixed(0)}",
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.0,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 32),
            Container(height: 1, color: theme.dividerColor),
            const SizedBox(height: 24),
          ],

          // Legend
          if (hasData)
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 24,
                runSpacing: 20,
                children: legendEntries.map((entry) {
                  final categoryColor = controller.getColor(entry.key);
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: categoryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "₹${entry.value.toStringAsFixed(0)}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: categoryColor.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
