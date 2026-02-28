import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/data/models/transaction_model.dart';
import 'package:test_app/presentation/controllers/view_all_transaction/view_all_transaction_controller.dart';

class ViewAllTransactionView extends GetView<ViewAllTransactionController> {
  const ViewAllTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          // Apple-style Large Title Header
          SliverAppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => Get.back(),
              child: Icon(
                CupertinoIcons.back,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            actions: [
              CupertinoButton(
                padding: const EdgeInsets.only(right: 16),
                onPressed: () => _showFilterBottomSheet(context),
                child: Icon(
                  CupertinoIcons.slider_horizontal_3,
                  color: colorScheme.primary,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                "Transactions",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  fontSize: 28,
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Center(child: CupertinoActivityIndicator(radius: 16)),
                );
              }

              if (controller.filteredTransactions.isEmpty) {
                return _buildEmptyState(theme, isDark);
              }

              return Column(
                children: [
                  // Summary Card
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: _buildSummaryCard(context, isDark),
                  ),
                  const SizedBox(height: 16),

                  // Transactions List Grouped
                  ...controller.groupedTransactions.keys.map((dateKey) {
                    final txList = controller.groupedTransactions[dateKey]!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 4,
                              bottom: 12,
                              top: 16,
                            ),
                            child: Text(
                              dateKey,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(24),
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
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: txList.length,
                              separatorBuilder: (context, index) => Container(
                                margin: const EdgeInsets.only(left: 72),
                                height: 0.5,
                                color: theme.dividerColor,
                              ),
                              itemBuilder: (context, index) =>
                                  _buildTransactionRow(
                                    context,
                                    txList[index],
                                    isDark,
                                    theme,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 80), // Bottom padding
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Center(
        child: Column(
          children: [
            Icon(
              CupertinoIcons.doc_text_search,
              size: 80,
              color: Colors.grey.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 24),
            Text(
              "No transactions yet",
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Add your first transaction to see it here.",
              style: TextStyle(
                color: isDark ? Colors.white54 : Colors.grey.shade500,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, bool isDark) {
    final theme = context.theme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF6C3FEE), const Color(0xFF4B23B5)]
              : [const Color(0xFF8B64FF), const Color(0xFF6C3FEE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF6C3FEE,
            ).withValues(alpha: isDark ? 0.3 : 0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "All Time Summary",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "₹${controller.totalBalance.value.toStringAsFixed(0)}",
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: 42,
              letterSpacing: -1.5,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Income",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "₹${controller.totalIncome.value.toStringAsFixed(0)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Expense",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "₹${controller.totalExpense.value.toStringAsFixed(0)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
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

  Widget _buildTransactionRow(
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
        color: const Color(0xFFFF3B30),
        child: const Icon(CupertinoIcons.trash, color: Colors.white, size: 24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                isIncome
                    ? CupertinoIcons.arrow_down_right
                    : CupertinoIcons.arrow_up_right,
                color: accentColor,
                size: 22,
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
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  if (tx.notes != null && tx.notes!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      tx.notes!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
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

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = context.theme;
        final isDark = Get.isDarkMode;

        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
          child: SafeArea(
            bottom: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dash
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Filter & Sort",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        controller.resetFilters();
                        Get.back();
                      },
                      child: Text(
                        "Reset",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Type Segment
                Text(
                  "TRANSACTION TYPE",
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: CupertinoSlidingSegmentedControl<String>(
                      groupValue: controller.selectedType.value,
                      padding: const EdgeInsets.all(4),
                      children: const {
                        'all': Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text("All"),
                        ),
                        'income': Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text("Income"),
                        ),
                        'expense': Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text("Expense"),
                        ),
                      },
                      onValueChanged: (val) {
                        if (val != null) {
                          controller.selectedType.value = val;
                          controller.applyFiltersAndSort();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Sort Chips
                Text(
                  "SORT BY",
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        [
                          {'label': 'Newest', 'value': 'newest'},
                          {'label': 'Oldest', 'value': 'oldest'},
                          {'label': 'Highest Amount', 'value': 'highest'},
                          {'label': 'Lowest Amount', 'value': 'lowest'},
                        ].map((item) {
                          final isSelected =
                              controller.selectedSort.value == item['value'];
                          return ChoiceChip(
                            label: Text(item['label'] as String),
                            selected: isSelected,
                            onSelected: (_) {
                              controller.selectedSort.value =
                                  item['value'] as String;
                              controller.applyFiltersAndSort();
                            },
                            backgroundColor: isDark
                                ? const Color(0xFF283040)
                                : const Color(0xFFF0F1F5),
                            selectedColor: theme.colorScheme.primary,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? Colors.white70 : Colors.black87),
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              fontSize: 15,
                            ),
                            side: BorderSide.none,
                          );
                        }).toList(),
                  ),
                ),
                const SizedBox(height: 32),

                // Category Dropdown
                Text(
                  "CATEGORY",
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF283040)
                          : const Color(0xFFF0F1F5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: controller.selectedCategory.value,
                        icon: const Icon(CupertinoIcons.chevron_down, size: 16),
                        dropdownColor: isDark
                            ? const Color(0xFF1E293B)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        items: controller.categories.map((cat) {
                          return DropdownMenuItem(
                            value: cat,
                            child: Text(
                              cat == 'all' ? 'All Categories' : cat,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
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
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
