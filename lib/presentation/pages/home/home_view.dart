import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/core/helpers/screen_helper.dart';
import 'package:test_app/data/models/transaction_model.dart';
import 'package:test_app/presentation/controllers/home/home_controller.dart';
import 'package:test_app/presentation/widgets/app_dialogs.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

// ── Neo Brutalism Design Tokens ─────────────────────────────────────────────
const _kBorder = BorderSide(color: Colors.black, width: 2.5);

const _kAccentYellow = Color(0xFFFFE600);
const _kAccentGreen = Color(0xFF00C853);
const _kAccentRed = Color(0xFFFF1744);

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

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
        title: Padding(
          padding: const .only(top: 8.0),
          child: Row(
            children: [
              Container(
                padding: const .symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _kAccentYellow,
                  border: .all(color: Colors.black, width: 2.5),
                ),
                child: const AppText(
                  'OVERVIEW',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 18,
                    fontWeight: .w900,
                    color: Colors.black,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const .only(top: 8.0, right: 16.0),
            child: Obx(
              () => GestureDetector(
                onTap: () => _showMonthYearPicker(context),
                child: Container(
                  padding: const .symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                    border: .all(color: Colors.black, width: 2.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(3, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      AppText(
                        controller.formattedMonth,
                        style: TextStyle(
                          fontWeight: .w800,
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      6.wBox,
                      Icon(
                        CupertinoIcons.chevron_down,
                        size: 13,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: ... REMOVED, now in LandingView
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Padding(
          padding: const .symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              // Balance Card
              Obx(() => _buildBalanceCard(context, isDark, cardBg)),
              20.hBox,

              // Income/Expense Cards
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => _buildStatCard(
                        label: 'INCOME',
                        amount:
                            '₹${controller.totalIncome.value.toStringAsFixed(2)}',
                        accentColor: _kAccentGreen,
                        isDark: isDark,
                        cardBg: cardBg,
                        arrowUp: false,
                      ),
                    ),
                  ),
                  12.wBox,
                  Expanded(
                    child: Obx(
                      () => _buildStatCard(
                        label: 'EXPENSE',
                        amount:
                            '₹${controller.totalExpense.value.toStringAsFixed(2)}',
                        accentColor: _kAccentRed,
                        isDark: isDark,
                        cardBg: cardBg,
                        arrowUp: true,
                      ),
                    ),
                  ),
                ],
              ),
              28.hBox,

              // Donut Chart
              _buildChartSection(context, isDark, cardBg),
              32.hBox,

              // Recent Transactions
              Row(
                children: [_nbLabel('RECENT', isDark)],
                // SEE ALL button REMOVED, now in LandingView tab
              ),
              14.hBox,

              // Transactions List
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CupertinoActivityIndicator());
                }

                if (controller.transactions.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const .symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Container(
                            padding: const .all(16),
                            decoration: BoxDecoration(
                              color: cardBg,
                              border: .all(color: Colors.black, width: 2.5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(4, 4),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                            child: Icon(
                              CupertinoIcons.doc_text_search,
                              size: 40,
                              color: isDark ? Colors.white54 : Colors.black54,
                            ),
                          ),
                          14.hBox,
                          AppText(
                            'NO TRANSACTIONS\nTHIS MONTH.',
                            align: TextAlign.center,
                            style: TextStyle(
                              fontWeight: .w900,
                              fontSize: 14,
                              letterSpacing: 1,
                              color: isDark ? Colors.white54 : Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.transactions.length > 6
                          ? 6
                          : controller.transactions.length,
                      padding: .zero,
                      separatorBuilder: (context, index) => 10.hBox,
                      itemBuilder: (context, index) {
                        final tx = controller.transactions[index];
                        return _buildTransactionTile(
                          context,
                          tx,
                          isDark,
                          cardBg,
                        );
                      },
                    ),
                    32.hBox,
                    _buildBarChartSection(context, isDark, cardBg),
                    120.hBox,
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // ── Neo Brutalism Label ─────────────────────────────────────────────────
  Widget _nbLabel(String text, bool isDark) {
    return Container(
      padding: const .symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white : Colors.black,
        border: .all(color: isDark ? Colors.white : Colors.black, width: 2),
      ),
      child: AppText(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: .w900,
          letterSpacing: 1.5,
          color: isDark ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  // ── Balance Card ────────────────────────────────────────────────────────
  Widget _buildBalanceCard(BuildContext context, bool isDark, Color cardBg) {
    return Container(
      width: double.infinity,
      padding: const .all(20),
      decoration: BoxDecoration(
        color: _kAccentYellow,
        border: const .fromBorderSide(_kBorder),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: .zero, blurRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          const AppText(
            'TOTAL BALANCE',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 2,
              color: Colors.black54,
            ),
          ),
          10.hBox,
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: AppText(
              '₹${controller.totalBalance.value.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 46,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stat Cards (Income / Expense) ───────────────────────────────────────
  Widget _buildStatCard({
    required String label,
    required String amount,
    required Color accentColor,
    required bool isDark,
    required Color cardBg,
    required bool arrowUp,
  }) {
    return Container(
      padding: const .all(14),
      decoration: BoxDecoration(
        color: cardBg,
        border: const .fromBorderSide(_kBorder),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Container(
            width: 36,
            height: 36,
            color: accentColor,
            child: Icon(
              arrowUp
                  ? CupertinoIcons.arrow_up_right
                  : CupertinoIcons.arrow_down_left,
              color: Colors.white,
              size: 20,
            ),
          ),
          10.hBox,
          AppText(
            label,
            style: TextStyle(
              fontWeight: .w900,
              fontSize: 11,
              letterSpacing: 1.5,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
          ),
          4.hBox,
          FittedBox(
            fit: .scaleDown,
            alignment: .centerLeft,
            child: AppText(
              amount,
              style: TextStyle(
                fontSize: 20,
                fontWeight: .w900,
                color: isDark ? Colors.white : Colors.black,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Chart Section ───────────────────────────────────────────────────────
  Widget _buildChartSection(BuildContext context, bool isDark, Color cardBg) {
    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: cardBg,
        border: const .fromBorderSide(_kBorder),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(5, 5), blurRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          _nbLabel('BREAKDOWN', isDark),
          20.hBox,
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
                        sectionsSpace: 3,
                        centerSpaceRadius: 78,
                        sections: controller.pieChartSections,
                      ),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: .min,
                        children: [
                          AppText(
                            controller.centerChartText.split('\n')[0],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: .w700,
                              letterSpacing: 1,
                              color: isDark ? Colors.white54 : Colors.black45,
                            ),
                          ),
                          4.hBox,
                          AppText(
                            (double.tryParse(
                                      controller.centerChartText.split('\n')[1],
                                    ) ??
                                    0)
                                .toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: .w900,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bar Chart Section ───────────────────────────────────────────────────
  Widget _buildBarChartSection(
    BuildContext context,
    bool isDark,
    Color cardBg,
  ) {
    if (controller.totalIncome.value == 0 &&
        controller.totalExpense.value == 0) {
      return const SizedBox.shrink();
    }

    final weeklyData = controller.getLast7DaysData();
    double currentMax = 0;
    for (var day in weeklyData) {
      if ((day['income'] as double) > currentMax)
        currentMax = day['income'] as double;
      if ((day['expense'] as double) > currentMax)
        currentMax = day['expense'] as double;
    }
    final maxY = currentMax == 0 ? 100.0 : currentMax * 1.3;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        border: const Border.fromBorderSide(_kBorder),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(5, 5), blurRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _nbLabel('7-DAY ACTIVITY', isDark),
          20.hBox,
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) =>
                        isDark ? Colors.black : Colors.white,
                    tooltipBorder: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final isIncome = rodIndex == 0;
                      return BarTooltipItem(
                        '${isIncome ? "INCOME" : "EXPENSE"}\n',
                        TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                        ),
                        children: [
                          TextSpan(
                            text: '₹${rod.toY.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: isIncome ? _kAccentGreen : _kAccentRed,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        );
                        int index = value.toInt();
                        if (index < 0 || index >= weeklyData.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            weeklyData[index]['label'],
                            style: style.copyWith(
                              color: isDark ? Colors.white54 : Colors.black54,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox.shrink();
                        return AppText(
                          value >= 1000
                              ? '${(value / 1000).toStringAsFixed(1)}K'
                              : value.toStringAsFixed(0),
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: isDark ? Colors.white12 : Colors.black12,
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: weeklyData.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> dayData = entry.value;

                  return BarChartGroupData(
                    x: index,
                    barsSpace: 4,
                    barRods: [
                      BarChartRodData(
                        toY: dayData['income'] as double,
                        color: _kAccentGreen,
                        width: 12,
                        borderRadius: BorderRadius.zero,
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      BarChartRodData(
                        toY: dayData['expense'] as double,
                        color: _kAccentRed,
                        width: 12,
                        borderRadius: BorderRadius.zero,
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          12.hBox,
          // Legend
          Row(
            children: [
              _chartLegend('INCOME', _kAccentGreen),
              16.wBox,
              _chartLegend('EXPENSE', _kAccentRed),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chartLegend(String label, Color color) {
    return Row(
      children: [
        Container(width: 14, height: 14, color: color),
        6.wBox,
        AppText(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: .w900,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  // ── Transaction Tile ────────────────────────────────────────────────────
  Widget _buildTransactionTile(
    BuildContext context,
    TransactionModel tx,
    bool isDark,
    Color cardBg,
  ) {
    final isIncome = tx.type == 'income';
    final accentColor = isIncome ? _kAccentGreen : _kAccentRed;

    return Dismissible(
      key: ValueKey(tx.id),
      direction: .endToStart,
      confirmDismiss: (direction) async {
        return await AppDialogs.showConfirmDialog(
          title: "DELETE TRANSACTION",
          content: "ARE YOU SURE YOU WANT TO DELETE THIS TRANSACTION?",
          isDestructive: true,
        );
      },
      onDismissed: (direction) {
        if (tx.id != null) {
          controller.deleteTransaction(tx.id!);
        }
      },
      background: Container(
        padding: const EdgeInsets.only(right: 16),
        alignment: Alignment.centerRight,
        color: _kAccentRed,
        child: const Icon(CupertinoIcons.trash, color: Colors.white, size: 22),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: cardBg,
          border: const Border.fromBorderSide(_kBorder),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(3, 3), blurRadius: 0),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              color: accentColor,
              child: Icon(
                isIncome
                    ? CupertinoIcons.arrow_down_left
                    : CupertinoIcons.arrow_up_right,
                color: Colors.white,
                size: 22,
              ),
            ),
            14.wBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  4.hBox,
                  Text(
                    DateFormat('MMM dd, yyyy').format(tx.date),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${isIncome ? '+' : '-'}₹${tx.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Month/Year Picker ───────────────────────────────────────────────────
  void _showMonthYearPicker(BuildContext context) async {
    final RxInt tempYear = controller.selectedMonth.value.year.obs;
    final RxInt tempMonth = controller.selectedMonth.value.month.obs;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        final isDark = Theme.of(sheetContext).brightness == Brightness.dark;
        final bg = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F5F0);
        final cardBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;

        return Container(
          decoration: BoxDecoration(
            color: bg,
            border: const Border(
              top: BorderSide(color: Colors.black, width: 2.5),
              left: BorderSide(color: Colors.black, width: 2.5),
              right: BorderSide(color: Colors.black, width: 2.5),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Grabber
              Container(width: 40, height: 4, color: Colors.black26),
              20.hBox,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                color: _kAccentYellow,
                child: const Text(
                  'SELECT MONTH',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: Colors.black,
                  ),
                ),
              ),
              20.hBox,
              // Year picker
              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(3, 3),
                      blurRadius: 0,
                    ),
                  ],
                ),
                height: 100,
                child: CupertinoPicker(
                  itemExtent: 36,
                  scrollController: FixedExtentScrollController(
                    initialItem: tempYear.value - 2020,
                  ),
                  onSelectedItemChanged: (idx) {
                    tempYear.value = 2020 + idx;
                  },
                  children: List.generate(
                    DateTime.now().year - 2020 + 2,
                    (index) => Center(
                      child: Text(
                        '${2020 + index}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              20.hBox,
              // Month Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.7,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  final month = index + 1;
                  return Obx(() {
                    final isSelected = month == tempMonth.value;
                    return GestureDetector(
                      onTap: () => tempMonth.value = month,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: isSelected ? _kAccentYellow : cardBg,
                          border: Border.all(color: Colors.black, width: 2),
                          boxShadow: isSelected
                              ? const [
                                  BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(2, 2),
                                    blurRadius: 0,
                                  ),
                                ]
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          DateFormat(
                            'MMM',
                          ).format(DateTime(2020, month)).toUpperCase(),
                          style: TextStyle(
                            color: isSelected
                                ? Colors.black
                                : (isDark ? Colors.white70 : Colors.black87),
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
              28.hBox,
              GestureDetector(
                onTap: () {
                  controller.selectMonth(
                    DateTime(tempYear.value, tempMonth.value),
                  );
                  Screen.close();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: const BoxDecoration(
                    color: _kAccentYellow,
                    border: Border.fromBorderSide(_kBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'APPLY',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
