import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/core/helpers/screen_helper.dart';
import 'package:test_app/data/models/transaction_model.dart';
import 'package:test_app/presentation/bindings/add_transaction/add_transaction_binding.dart';
import 'package:test_app/presentation/controllers/transactions/transactions_controller.dart';
import 'package:test_app/presentation/pages/add_transaction/add_transaction_view.dart';
import 'package:intl/intl.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

// ── Neo Brutalism tokens ─────────────────────────────────────────────────────
const _kAccentYellow = Color(0xFFFFE600);
const _kAccentGreen = Color(0xFF00C853);
const _kAccentRed = Color(0xFFFF1744);
const _kAccentBlue = Color(0xFF2979FF);
const _kAccentPurple = Color(0xFF7C4DFF);

class TransactionsView extends GetView<TransactionsController> {
  const TransactionsView({super.key});

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
        centerTitle: true,
        title: Padding(
          padding: const .only(top: 8.0),
          child: Container(
            padding: const .symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _kAccentYellow,
              border: .all(color: Colors.black, width: 2.5),
            ),
            child: const AppText(
              'ALL TRANSACTIONS',
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
        actions: [
          Padding(
            padding: const .only(top: 8.0, right: 16.0),
            child: GestureDetector(
              onTap: () => _showFilterBottomSheet(context),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _kAccentBlue,
                  border: .all(color: Colors.black, width: 2.5),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, offset: Offset(3, 3)),
                  ],
                ),
                child: const Icon(
                  CupertinoIcons.slider_horizontal_3,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const .only(bottom: 80),
        child: GestureDetector(
          onTap: () async {
            await Screen.open(
              const AddTransactionView(),
              binding: AddTransactionBinding(),
            );
            controller.fetchTransactions();
          },
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: _kAccentYellow,
              border: .all(color: Colors.black, width: 2.5),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(4, 4)),
              ],
            ),
            child: const Icon(
              CupertinoIcons.plus,
              color: Colors.black,
              size: 30,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CupertinoActivityIndicator(radius: 16));
        }

        if (controller.allTransactions.isEmpty) {
          return _buildEmptyState(
            isDark,
            cardBg,
            "NO TRANSACTIONS YET",
            "START BY ADDING A NEW TRANSACTION",
          );
        }

        if (controller.filteredTransactions.isEmpty) {
          return _buildEmptyState(
            isDark,
            cardBg,
            "NO MATCHES FOUND",
            "TRY ADJUSTING YOUR FILTERS",
          );
        }

        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: const .symmetric(horizontal: 16, vertical: 20),
          children: [
            // ── All-Time Summary Row ─────────────────────────────────────────
            _buildSummaryRow(
              controller.totalIncome.value,
              controller.totalExpense.value,
              isDark,
            ),
            24.hBox,

            // ── Dynamic Date-Grouped History ─────────────────────────────────
            ...controller.groupedTransactions.keys.map((dateKey) {
              final txList = controller.groupedTransactions[dateKey]!;
              return Column(
                crossAxisAlignment: .start,
                children: [
                  _nbLabel(dateKey.toUpperCase(), isDark),
                  12.hBox,
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: .zero,
                    itemCount: txList.length,
                    separatorBuilder: (_, __) => 16.hBox,
                    itemBuilder: (ctx, idx) =>
                        _buildTransactionCard(ctx, txList[idx], isDark, cardBg),
                  ),
                ],
              );
            }).toList(),
            80.hBox, // Padding for floating bottom bar area
          ],
        );
      }),
    );
  }

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
          fontSize: 12,
          fontWeight: .w900,
          letterSpacing: 1.5,
          color: isDark ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  Widget _buildSummaryRow(double income, double expense, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _summaryBox(
            "TOTAL INCOME",
            "₹${income.toStringAsFixed(2)}",
            _kAccentGreen,
            isDark,
          ),
        ),
        12.wBox,
        Expanded(
          child: _summaryBox(
            "TOTAL EXPENSE",
            "₹${expense.toStringAsFixed(2)}",
            _kAccentRed,
            isDark,
          ),
        ),
      ],
    );
  }

  Widget _summaryBox(
    String label,
    String value,
    Color accentColor,
    bool isDark,
  ) {
    return Container(
      padding: const .all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        border: .all(color: Colors.black, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(3, 3))],
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          AppText(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: .w900,
              color: Colors.grey,
            ),
          ),
          4.hBox,
          FittedBox(
            fit: .scaleDown,
            child: AppText(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: .w900,
                color: accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    bool isDark,
    Color cardBg,
    String title,
    String subtitle,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Container(
            padding: const .all(24),
            decoration: BoxDecoration(
              color: cardBg,
              border: .all(color: Colors.black, width: 2.5),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(5, 5)),
              ],
            ),
            child: Icon(
              CupertinoIcons.doc_text_search,
              size: 50,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
          ),
          24.hBox,
          AppText(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: .w900,
              letterSpacing: 1,
            ),
          ),
          8.hBox,
          AppText(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: .w700,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(
    BuildContext context,
    TransactionModel tx,
    bool isDark,
    Color cardBg,
  ) {
    final isIncome = tx.type == 'income';
    final accentColor = isIncome ? _kAccentGreen : _kAccentRed;

    return Dismissible(
      key: ValueKey("tx_${tx.id}"),
      direction: .endToStart,
      confirmDismiss: (direction) async => await _showDeleteDialog(context),
      onDismissed: (_) {
        if (tx.id != null) controller.deleteTransaction(tx.id!);
      },
      background: Container(
        padding: const .only(right: 20),
        alignment: .centerRight,
        decoration: BoxDecoration(
          color: _kAccentRed,
          border: .all(color: Colors.black, width: 2),
        ),
        child: const Icon(CupertinoIcons.trash, color: Colors.white, size: 24),
      ),
      child: Container(
        padding: const .all(16),
        decoration: BoxDecoration(
          color: cardBg,
          border: .all(color: Colors.black, width: 2.5),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accentColor,
                border: .all(color: Colors.black, width: 2),
              ),
              child: Icon(
                isIncome
                    ? CupertinoIcons.arrow_down_left
                    : CupertinoIcons.arrow_up_right,
                color: Colors.white,
                size: 24,
              ),
            ),
            16.wBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    tx.category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: .w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (tx.notes != null && tx.notes!.isNotEmpty) ...[
                    4.hBox,
                    AppText(
                      tx.notes!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: .w600,
                        color: isDark ? Colors.white54 : Colors.black45,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: .end,
              children: [
                AppText(
                  "${isIncome ? '+' : '-'}₹${tx.amount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: .w900,
                    color: accentColor,
                  ),
                ),
                2.hBox,
                AppText(
                  DateFormat('hh:mm a').format(tx.createdAt),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: .w700,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context) async {
    return await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const AppText("DELETE TRANSACTION?"),
        content: const AppText("ARE YOU SURE YOU WANT TO DELETE THIS ITEM?"),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Screen.close(result: false),
            child: const AppText("CANCEL"),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Screen.close(result: true),
            child: const AppText("DELETE"),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == .dark;
        final bg = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F5F0);

        return Container(
          decoration: BoxDecoration(
            color: bg,
            border: const Border(
              top: BorderSide(color: Colors.black, width: 2.5),
              left: BorderSide(color: Colors.black, width: 2.5),
              right: BorderSide(color: Colors.black, width: 2.5),
            ),
          ),
          padding: const .fromLTRB(20, 24, 20, 40),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              _nbLabel("FILTER & SORT", isDark),
              32.hBox,

              // Type Segmented
              const AppText(
                "TRANSACTION TYPE",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: .w900,
                  letterSpacing: 1.5,
                  color: Colors.grey,
                ),
              ),
              12.hBox,
              Obx(
                () => Row(
                  children: [
                    _filterTab(
                      "ALL",
                      "all",
                      controller.selectedType.value == 'all',
                      isDark,
                    ),
                    12.wBox,
                    _filterTab(
                      "INCOME",
                      "income",
                      controller.selectedType.value == 'income',
                      isDark,
                    ),
                    12.wBox,
                    _filterTab(
                      "EXPENSE",
                      "expense",
                      controller.selectedType.value == 'expense',
                      isDark,
                    ),
                  ],
                ),
              ),
              32.hBox,

              // Sorting
              const AppText(
                "SORT ORDER",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: .w900,
                  letterSpacing: 1.5,
                  color: Colors.grey,
                ),
              ),
              12.hBox,
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _sortChip("NEWEST", "newest"),
                  _sortChip("OLDEST", "oldest"),
                  _sortChip("HIGHEST", "highest"),
                  _sortChip("LOWEST", "lowest"),
                ],
              ),
              32.hBox,

              // Reset Button
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    controller.resetFilters();
                    Screen.close();
                  },
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: .all(color: Colors.white, width: 1.5),
                      boxShadow: const [
                        BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const AppText(
                      "RESET ALL FILTERS",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: .w900,
                        letterSpacing: 1.5,
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

  Widget _filterTab(String label, String value, bool isSelected, bool isDark) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectedType.value = value,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: isSelected
                ? _kAccentYellow
                : (isDark ? Colors.white12 : Colors.black12),
            border: .all(color: Colors.black, width: 2),
            boxShadow: isSelected
                ? const [BoxShadow(color: Colors.black, offset: Offset(2, 2))]
                : [],
          ),
          alignment: Alignment.center,
          child: AppText(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: .w900,
              color: isSelected
                  ? Colors.black
                  : (isDark ? Colors.white54 : Colors.black54),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sortChip(String label, String value) {
    return Obx(() {
      final isSelected = controller.selectedSort.value == value;
      return GestureDetector(
        onTap: () => controller.selectedSort.value = value,
        child: Container(
          padding: const .symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? _kAccentPurple : Colors.white,
            border: .all(color: Colors.black, width: 2),
            boxShadow: isSelected
                ? const [BoxShadow(color: Colors.black, offset: Offset(2, 2))]
                : [],
          ),
          child: AppText(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: .w900,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      );
    });
  }
}
