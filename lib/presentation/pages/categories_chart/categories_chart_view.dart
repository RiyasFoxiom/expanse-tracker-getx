import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/core/helpers/screen_helper.dart';
import 'package:test_app/presentation/controllers/categories_chart/categories_chart_controller.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

// ── Neo Brutalism tokens ─────────────────────────────────────────────────────
const _kBorder = BorderSide(color: Colors.black, width: 2.5);
const _kAccentYellow = Color(0xFFFFE600);
const _kAccentGreen = Color(0xFF00C853);
const _kAccentRed = Color(0xFFFF1744);

class CategoriesChartView extends GetView<CategoriesChartController> {
  const CategoriesChartView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == .dark;
    final bg = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F5F0);
    final cardBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 60,
        centerTitle: false,
        leading: GestureDetector(
          onTap: () => Screen.close(),
          child: Container(
            margin: const .only(left: 16, top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: isDark ? Colors.white : Colors.black,
              border: .all(
                color: isDark ? Colors.white : Colors.black,
                width: 2,
              ),
            ),
            child: Icon(
              CupertinoIcons.back,
              color: isDark ? Colors.black : Colors.white,
            ),
          ),
        ),
        title: Padding(
          padding: const .only(top: 8.0),
          child: Container(
            padding: const .symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _kAccentYellow,
              border: .fromBorderSide(_kBorder),
            ),
            child: const AppText(
              'CHARTS',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
                fontWeight: .w900,
                color: Colors.black,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CupertinoActivityIndicator(radius: 16));
        }

        return ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const .symmetric(horizontal: 16, vertical: 24),
          children: [
            // Income Chart
            _buildChartCard(
              context: context,
              title: "INCOME BY CATEGORY",
              total: controller.totalIncome.value,
              sections: controller.incomePieSections,
              legendEntries: controller.incomeCategoryTotals.entries,
              noDataText: "NO RECORDED INCOME",
              isIncome: true,
              isDark: isDark,
              cardBg: cardBg,
            ),
            32.hBox,

            // Expense Chart
            _buildChartCard(
              context: context,
              title: "EXPENSE BY CATEGORY",
              total: controller.totalExpense.value,
              sections: controller.expensePieSections,
              legendEntries: controller.expenseCategoryTotals.entries,
              noDataText: "NO RECORDED EXPENSES",
              isIncome: false,
              isDark: isDark,
              cardBg: cardBg,
            ),
            100.hBox,
          ],
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
    required bool isDark,
    required Color cardBg,
  }) {
    final hasData = total > 0;
    final accentColor = isIncome ? _kAccentGreen : _kAccentRed;

    return Container(
      width: double.infinity,
      padding: const .all(16),
      decoration: BoxDecoration(
        color: cardBg,
        border: const .fromBorderSide(_kBorder),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Container(
            padding: const .symmetric(horizontal: 10, vertical: 4),
            color: isDark ? Colors.white : Colors.black,
            child: AppText(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: .w900,
                letterSpacing: 1.5,
                color: isDark ? Colors.black : Colors.white,
              ),
            ),
          ),
          32.hBox,

          SizedBox(
            height: 240,
            child: hasData
                ? PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(enabled: false),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 4,
                      centerSpaceRadius: 60,
                      sections: sections,
                    ),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                  )
                : Center(
                    child: Column(
                      mainAxisSize: .min,
                      children: [
                        Icon(
                          isIncome
                              ? CupertinoIcons.chart_bar_fill
                              : CupertinoIcons.chart_pie_fill,
                          size: 60,
                          color: isDark ? Colors.white24 : Colors.black26,
                        ),
                        16.hBox,
                        AppText(
                          noDataText,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white54 : Colors.black54,
                            fontWeight: .w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),

          if (hasData) ...[
            20.hBox,
            Container(
              padding: const .only(left: 12, top: 4, bottom: 4),
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: accentColor, width: 4)),
              ),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  AppText(
                    "TOTAL",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: .w900,
                      color: isDark ? Colors.white54 : Colors.black54,
                      letterSpacing: 1.5,
                    ),
                  ),
                  4.hBox,
                  AppText(
                    "₹${total.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: .w900,
                      letterSpacing: -1.0,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),
            16.hBox,
            Container(height: 2.5, color: Colors.black),
            16.hBox,
          ],

          // Legend
          if (hasData)
            Align(
              alignment: .centerLeft,
              child: Wrap(
                spacing: 24,
                runSpacing: 20,
                children: legendEntries.map((entry) {
                  final categoryColor = controller.getColor(entry.key);
                  return Row(
                    mainAxisSize: .min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: categoryColor,
                          border: .all(color: Colors.black, width: 2),
                        ),
                      ),
                      10.wBox,
                      Column(
                        crossAxisAlignment: .start,
                        children: [
                          AppText(
                            entry.key.toUpperCase(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: .w900,
                              letterSpacing: 1,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          4.hBox,
                          AppText(
                            "₹${entry.value.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: .w900,
                              color: isDark ? Colors.white54 : Colors.black54,
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
