import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/core/helpers/screen_helper.dart';
import 'package:test_app/data/models/transaction_model.dart';
import 'package:test_app/presentation/controllers/view_all_transaction/view_all_transaction_controller.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

// ── Neo Brutalism tokens ─────────────────────────────────────────────────────
const _kBorder = BorderSide(color: Colors.black, width: 2.5);
const _kAccentYellow = Color(0xFFFFE600);
const _kAccentGreen = Color(0xFF00C853);
const _kAccentRed = Color(0xFFFF1744);
const _kAccentBlue = Color(0xFF2979FF);
const _kAccentPurple = Color(0xFF7C4DFF);

class ViewAllTransactionView extends GetView<ViewAllTransactionController> {
  const ViewAllTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
              border: .all(color: Colors.black, width: 2.5),
            ),
            child: const AppText(
              'TRANSACTIONS',
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
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(3, 3),
                      blurRadius: 0,
                    ),
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CupertinoActivityIndicator(radius: 16));
        }

        if (controller.filteredTransactions.isEmpty) {
          return _buildEmptyState(isDark, cardBg);
        }

        return ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const .symmetric(vertical: 16),
          children: [
            // Summary Card
            Padding(
              padding: const .symmetric(horizontal: 16),
              child: _buildSummaryCard(isDark, cardBg),
            ),
            24.hBox,

            // Transactions List Grouped
            ...controller.groupedTransactions.keys.map((dateKey) {
              final txList = controller.groupedTransactions[dateKey]!;

              return Padding(
                padding: const .only(left: 16, right: 16, bottom: 24),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    _nbLabel(dateKey.toUpperCase(), isDark),
                    12.hBox,
                    Container(
                      decoration: BoxDecoration(
                        color: cardBg,
                        border: .fromBorderSide(_kBorder),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(5, 5),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: txList.length,
                        separatorBuilder: (_, _) =>
                            Container(height: 2.5, color: Colors.black),
                        itemBuilder: (_, index) => _buildTransactionRow(
                          context,
                          txList[index],
                          isDark,
                          cardBg,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            80.hBox, // Bottom padding
          ],
        );
      }),
    );
  }

  // ── Section Label ──────────────────────────────────────────────────────────
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

  // ── Empty State ────────────────────────────────────────────────────────────
  Widget _buildEmptyState(bool isDark, Color cardBg) {
    return Center(
      child: Padding(
        padding: const .symmetric(vertical: 40),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Container(
              padding: const .all(20),
              decoration: BoxDecoration(
                color: cardBg,
                border: .all(color: Colors.black, width: 2.5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(5, 5),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Icon(
                CupertinoIcons.doc_text_search,
                size: 50,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
            ),
            16.hBox,
            AppText(
              'NO TRANSACTIONS\nMATCHING FILTER.',
              align: .center,
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

  // ── Summary Card ───────────────────────────────────────────────────────────
  Widget _buildSummaryCard(bool isDark, Color cardBg) {
    return Container(
      width: double.infinity,
      padding: const .all(16),
      decoration: const BoxDecoration(
        color: _kAccentPurple,
        border: .fromBorderSide(_kBorder),
        boxShadow: [
          BoxShadow(color: Colors.black, offset: Offset(6, 6), blurRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Container(
            padding: const .symmetric(horizontal: 8, vertical: 3),
            color: Colors.black,
            child: const AppText(
              'ALL TIME SUMMARY',
              style: TextStyle(
                fontSize: 11,
                fontWeight: .w900,
                letterSpacing: 1.5,
                color: Colors.white,
              ),
            ),
          ),
          // 12.hBox,
          FittedBox(
            fit: .scaleDown,
            alignment: .centerLeft,
            child: AppText(
              '₹${controller.totalBalance.value.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 46,
                fontWeight: .w900,
                letterSpacing: -1,
                color: Colors.white,
              ),
            ),
          ),
          8.hBox,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    const AppText(
                      'INCOME',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: .w900,
                        letterSpacing: 1.5,
                        color: Colors.white70,
                      ),
                    ),
                    4.hBox,
                    FittedBox(
                      fit: .scaleDown,
                      alignment: .centerLeft,
                      child: AppText(
                        '₹${controller.totalIncome.value.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: .w900,
                          color: _kAccentGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: .end,
                  children: [
                    const AppText(
                      'EXPENSE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: .w900,
                        letterSpacing: 1.5,
                        color: Colors.white70,
                      ),
                    ),
                    4.hBox,
                    FittedBox(
                      fit: .scaleDown,
                      alignment: .centerRight,
                      child: AppText(
                        '₹${controller.totalExpense.value.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: .w900,
                          color:
                              _kAccentYellow, // Changed to Yellow for contrast on Purple
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Transaction Row ────────────────────────────────────────────────────────
  Widget _buildTransactionRow(
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
        return await showCupertinoDialog<bool>(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const AppText("Delete Transaction"),
            content: const AppText(
              "Are you sure you want to delete this transaction?",
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => Screen.close(result: false),
                child: const AppText("Cancel"),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () => Screen.close(result: true),
                child: const AppText("Delete"),
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
        padding: const .only(right: 20),
        alignment: .centerRight,
        color: _kAccentRed,
        child: const Icon(CupertinoIcons.trash, color: Colors.white, size: 24),
      ),
      child: Container(
        padding: const .symmetric(horizontal: 16, vertical: 16),
        color: cardBg,
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
            16.wBox,
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  AppText(
                    tx.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: .w900,
                      letterSpacing: 0.5,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  if (tx.notes != null && tx.notes!.isNotEmpty) ...[
                    4.hBox,
                    AppText(
                      tx.notes!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: .w600,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            AppText(
              "${isIncome ? '+' : '-'}₹${tx.amount.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: .w900,
                color: accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Filter Bottom Sheet ───────────────────────────────────────────────────
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final isDark = Theme.of(sheetContext).brightness == .dark;
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
          padding: const .fromLTRB(20, 16, 20, 40),
          child: SafeArea(
            bottom: true,
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: .start,
              children: [
                // Grabber
                Center(
                  child: Container(width: 40, height: 4, color: Colors.black26),
                ),
                24.hBox,

                // Header
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Container(
                      padding: const .symmetric(horizontal: 10, vertical: 4),
                      color: _kAccentYellow,
                      child: const AppText(
                        "FILTER & SORT",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: .w900,
                          letterSpacing: 2,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.resetFilters();
                        Screen.close();
                      },
                      child: Container(
                        padding: const .symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _kAccentRed,
                          border: .all(color: Colors.black, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: const AppText(
                          "RESET",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: .w900,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                32.hBox,

                // Type Segment
                Row(
                  children: [
                    Container(width: 4, height: 16, color: _kAccentYellow),
                    8.wBox,
                    AppText(
                      "TRANSACTION TYPE",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: .w900,
                        letterSpacing: 1.5,
                        color: isDark ? Colors.white60 : Colors.black45,
                      ),
                    ),
                  ],
                ),
                12.hBox,
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        border: .all(color: Colors.black, width: 2.5),
                        color: cardBg,
                        boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                        ],
                      ),
                      child: Row(
                        children: [
                          _buildSegmentBtn('All', 'all', isDark),
                          Container(
                            width: 2.5,
                            height: 40,
                            color: Colors.black,
                          ),
                          _buildSegmentBtn('Income', 'income', isDark),
                          Container(
                            width: 2.5,
                            height: 40,
                            color: Colors.black,
                          ),
                          _buildSegmentBtn('Expense', 'expense', isDark),
                        ],
                      ),
                    ),
                  ),
                ),
                32.hBox,

                // Sort Chips
                Row(
                  children: [
                    Container(width: 4, height: 16, color: _kAccentYellow),
                    8.wBox,
                    AppText(
                      "SORT BY",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: .w900,
                        letterSpacing: 1.5,
                        color: isDark ? Colors.white60 : Colors.black45,
                      ),
                    ),
                  ],
                ),
                12.hBox,
                Obx(
                  () => Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        [
                          {'label': 'NEWEST', 'value': 'newest'},
                          {'label': 'OLDEST', 'value': 'oldest'},
                          {'label': 'HIGHEST AMT', 'value': 'highest'},
                          {'label': 'LOWEST AMT', 'value': 'lowest'},
                        ].map((item) {
                          final isSelected =
                              controller.selectedSort.value == item['value'];
                          return GestureDetector(
                            onTap: () {
                              controller.selectedSort.value =
                                  item['value'] as String;
                              controller.applyFiltersAndSort();
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const .symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected ? _kAccentBlue : cardBg,
                                border: .all(color: Colors.black, width: 2),
                                boxShadow: isSelected
                                    ? const [
                                        BoxShadow(
                                          color: Colors.black,
                                          offset: Offset(3, 3),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: AppText(
                                item['label'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: .w900,
                                  letterSpacing: 1,
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark ? Colors.white : Colors.black),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
                32.hBox,

                // Category Dropdown
                Row(
                  children: [
                    Container(width: 4, height: 16, color: _kAccentYellow),
                    8.wBox,
                    AppText(
                      "CATEGORY",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: .w900,
                        letterSpacing: 1.5,
                        color: isDark ? Colors.white60 : Colors.black45,
                      ),
                    ),
                  ],
                ),
                12.hBox,
                Obx(
                  () => Container(
                    padding: const .symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      border: .all(color: Colors.black, width: 2.5),
                      boxShadow: const [
                        BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: controller.selectedCategory.value,
                        icon: Icon(
                          CupertinoIcons.chevron_down,
                          size: 20,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        dropdownColor: cardBg,
                        items: controller.categories.map((cat) {
                          return DropdownMenuItem(
                            value: cat,
                            child: AppText(
                              cat == 'all'
                                  ? 'ALL CATEGORIES'
                                  : cat.toUpperCase(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: .w900,
                                letterSpacing: 1,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedCategory.value = value;
                            controller.applyFiltersAndSort();
                          }
                        },
                      ),
                    ),
                  ),
                ),
                24.hBox,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSegmentBtn(String label, String value, bool isDark) {
    final isSelected = controller.selectedType.value == value;
    final accent = value == 'income'
        ? _kAccentGreen
        : (value == 'expense' ? _kAccentRed : _kAccentYellow);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.selectedType.value = value;
          controller.applyFiltersAndSort();
        },
        behavior: .opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 40,
          color: isSelected ? accent : Colors.transparent,
          alignment: .center,
          child: AppText(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: .w900,
              letterSpacing: 1,
              color: isSelected
                  ? (value == 'all' ? Colors.black : Colors.white)
                  : (isDark ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
