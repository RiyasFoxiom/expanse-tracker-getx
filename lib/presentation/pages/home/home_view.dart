import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_app/core/helpers/screen_helper.dart';
import 'package:test_app/data/models/transaction_model.dart';
import 'package:test_app/presentation/bindings/add_transaction/add_transaction_binding.dart';
import 'package:test_app/presentation/bindings/view_all_transaction/view_all_transaction_binding.dart';
import 'package:test_app/presentation/controllers/home/home_controller.dart';
import 'package:test_app/presentation/pages/add_transaction/add_transaction_view.dart';
import 'package:test_app/presentation/pages/view_transaction/view_all_transaction_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // Apple-like transparent Appbar blending into background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Overview",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, right: 16.0),
            child: Obx(
              () => CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => _showMonthYearPicker(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF283040)
                        : const Color(0xFFF0F1F5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text(
                        controller.formattedMonth,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        CupertinoIcons.chevron_down,
                        size: 14,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: FloatingActionButton(
          onPressed: () {
            Screen.open(
              const AddTransactionView(),
              binding: AddTransactionBinding(),
            );
          },
          child: const Icon(CupertinoIcons.plus, size: 28),
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Premium Balance Card
              Obx(() => _buildBalanceCard(context, isDark)),
              const SizedBox(height: 24),

              // Income/Expense Twin Cards
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => _buildPillCard(
                        context: context,
                        title: "Income",
                        amount:
                            "₹${controller.totalIncome.value.toStringAsFixed(0)}",
                        icon: CupertinoIcons.arrow_down_circle_fill,
                        color: const Color(0xFF34C759),
                        isDark: isDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Obx(
                      () => _buildPillCard(
                        context: context,
                        title: "Expense",
                        amount:
                            "₹${controller.totalExpense.value.toStringAsFixed(0)}",
                        icon: CupertinoIcons.arrow_up_circle_fill,
                        color: const Color(0xFFFF3B30),
                        isDark: isDark,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),

              // Ring Chart Section
              _buildChartSection(context, isDark),
              const SizedBox(height: 40),

              // Recent Transactions Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Transactions",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Screen.open(
                        const ViewAllTransactionView(),
                        binding: ViewAllTransactionBinding(),
                      );
                    },
                    child: Text(
                      "See All",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Transactions List
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CupertinoActivityIndicator());
                }

                if (controller.transactions.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(
                            CupertinoIcons.doc_text_search,
                            size: 48,
                            color: Colors.grey.withValues(alpha: 0.4),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "No transactions this month.",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
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
                      padding: EdgeInsets.zero,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final tx = controller.transactions[index];
                        return _buildTransactionTile(
                          context,
                          tx,
                          isDark,
                          theme,
                        );
                      },
                    ),
                    const SizedBox(height: 36),
                    _buildBarChartSection(context, isDark, theme),
                    const SizedBox(height: 120),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // ── Balance Card ───────────────────────────────────────────────────
  Widget _buildBalanceCard(BuildContext context, bool isDark) {
    final theme = context.theme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total Balance",
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.grey.shade500,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "₹${controller.totalBalance.value.toStringAsFixed(0)}",
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: 42,
              letterSpacing: -1.5,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ── Pill Card ──────────────────────────────────────────────────────
  Widget _buildPillCard({
    required BuildContext context,
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ── Chart Section ──────────────────────────────────────────────────
  Widget _buildChartSection(BuildContext context, bool isDark) {
    return Center(
      child: SizedBox(
        height: 240,
        width: 240,
        child: Obx(
          () => Stack(
            children: [
              PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(enabled: false),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 4,
                  centerSpaceRadius: 85,
                  sections: controller.pieChartSections,
                ),
                swapAnimationDuration: const Duration(milliseconds: 600),
                swapAnimationCurve: Curves.easeOutCubic,
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.centerChartText.split('\n')[0],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white54 : Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.centerChartText.split('\n')[1],
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
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
    );
  }

  // ── Bar Chart Section ──────────────────────────────────────────────
  Widget _buildBarChartSection(
    BuildContext context,
    bool isDark,
    ThemeData theme,
  ) {
    if (controller.totalIncome.value == 0 &&
        controller.totalExpense.value == 0) {
      return const SizedBox.shrink();
    }

    final maxY =
        (controller.totalIncome.value > controller.totalExpense.value
            ? controller.totalIncome.value
            : controller.totalExpense.value) *
        1.2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Balance Breakdown",
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 240,
          padding: const EdgeInsets.only(
            top: 32,
            bottom: 16,
            left: 16,
            right: 16,
          ),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY == 0 ? 100 : maxY,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      const style = TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      );
                      int index = value.toInt();
                      final data = controller.getLast7DaysData();
                      if (index < 0 || index >= data.length) {
                        return const SizedBox.shrink();
                      }

                      String text = data[index]['label'];
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          text,
                          style: style.copyWith(
                            color: isDark
                                ? Colors.white54
                                : Colors.grey.shade600,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: controller.getLast7DaysData().asMap().entries.map((
                entry,
              ) {
                int index = entry.key;
                Map<String, dynamic> dayData = entry.value;

                return BarChartGroupData(
                  x: index,
                  barsSpace: 4,
                  barRods: [
                    BarChartRodData(
                      toY: dayData['income'] as double,
                      color: const Color(0xFF34C759),
                      width: 10,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    BarChartRodData(
                      toY: dayData['expense'] as double,
                      color: const Color(0xFFFF3B30),
                      width: 10,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // ── Transaction Tile ───────────────────────────────────────────────
  Widget _buildTransactionTile(
    BuildContext context,
    TransactionModel tx,
    bool isDark,
    ThemeData theme,
  ) {
    final isIncome = tx.type == 'income';
    final accentColor = isIncome
        ? const Color(0xFF34C759)
        : const Color(0xFFFF3B30);

    return Dismissible(
      key: ValueKey(tx.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showCupertinoDialog<bool>(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text("Delete Transaction"),
            content: const Text(
              "Are you sure you want to delete this transaction?",
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Delete"),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        if (tx.id != null) {
          controller.deleteTransaction(tx.id!);
        }
      },
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: const Color(0xFFFF3B30),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(CupertinoIcons.trash, color: Colors.white, size: 24),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isIncome
                    ? CupertinoIcons.arrow_down_right
                    : CupertinoIcons.arrow_up_right,
                color: accentColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.category,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM dd, yyyy').format(tx.date),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white54 : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "${isIncome ? '+' : '-'}₹${tx.amount.toStringAsFixed(0)}",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: accentColor,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Month Year Picker ──────────────────────────────────────────────
  void _showMonthYearPicker(BuildContext context) async {
    final isDark = Get.isDarkMode;
    final theme = Theme.of(context);
    final RxInt tempYear = controller.selectedMonth.value.year.obs;
    final RxInt tempMonth = controller.selectedMonth.value.month.obs;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Grabber
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Select Month",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              // Year Swipe
              SizedBox(
                height: 120,
                child: CupertinoPicker(
                  itemExtent: 40,
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
                        "${2020 + index}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Month Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.6,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  final month = index + 1;
                  return Obx(() {
                    final isSelected = month == tempMonth.value;
                    return GestureDetector(
                      onTap: () => tempMonth.value = month,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : (isDark
                                    ? const Color(0xFF283040)
                                    : const Color(0xFFF0F1F5)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          DateFormat('MMM').format(DateTime(2020, month)),
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : (isDark ? Colors.white70 : Colors.black87),
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.selectMonth(
                      DateTime(tempYear.value, tempMonth.value),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text("Apply", style: TextStyle(fontSize: 17)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
