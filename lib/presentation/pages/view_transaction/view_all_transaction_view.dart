import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/data/models/transaction_model.dart';
import 'package:test_app/presentation/controllers/view_all_transaction/view_all_transaction_controller.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

class ViewAllTransactionView extends GetView<ViewAllTransactionController> {
  const ViewAllTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = Get.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          "All Transactions",
          size: 22,
          weight: FontWeight.bold,
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
          8.wBox,
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CupertinoActivityIndicator());
        }

        if (controller.filteredTransactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 80,
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                16.hBox,
                AppText(
                  "No transactions yet",
                  size: 18,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                8.hBox,
                AppText(
                  "Add your first transaction to see it here",
                  size: 14,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Summary Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: const [Color(0xff4facfe), Color(0xff00f2fe)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText("All Time Summary", color: Colors.white70, size: 15),
                  8.hBox,
                  AppText(
                    "₹${controller.totalBalance.value.toStringAsFixed(0)}",
                    color: Colors.white,
                    size: 34,
                    weight: FontWeight.bold,
                  ),
                  20.hBox,
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText("Income", color: Colors.white70, size: 14),
                            AppText(
                              "₹${controller.totalIncome.value.toStringAsFixed(0)}",
                              color: Colors.white,
                              size: 20,
                              weight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            AppText("Expense", color: Colors.white70, size: 14),
                            AppText(
                              "₹${controller.totalExpense.value.toStringAsFixed(0)}",
                              color: Colors.white,
                              size: 20,
                              weight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Transaction List (Now properly wrapped in Expanded)
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.fetchTransactions,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // Grouped Transactions
                    ...controller.groupedTransactions.keys.map((dateKey) {
                      final txList = controller.groupedTransactions[dateKey]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 4,
                            ),
                            child: AppText(
                              dateKey,
                              size: 17,
                              weight: FontWeight.bold,
                              color: textTheme.titleMedium?.color,
                            ),
                          ),
                          ...txList.map((tx) => _transactionTile(tx, isDark)),
                          8.hBox,
                        ],
                      );
                    }),
                    80.hBox, // Extra space for pull-to-refresh
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _transactionTile(TransactionModel tx, bool isDark) {
    final bool isIncome = tx.type == 'income';
    final Color typeColor = isIncome ? Colors.green : Colors.red;
    final Color bgTint = typeColor.withValues(alpha: isDark ? 0.15 : 0.1);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: bgTint,
            child: Icon(
              isIncome
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: typeColor,
              size: 26,
            ),
          ),
          16.wBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(tx.category, size: 17, weight: FontWeight.w600),
                if (tx.notes != null && tx.notes!.isNotEmpty) ...[
                  6.hBox,
                  AppText(
                    tx.notes!,
                    size: 14,
                    color: Colors.grey.shade600,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          AppText(
            "${isIncome ? '+' : '-'}₹${tx.amount.toStringAsFixed(0)}",
            size: 18,
            weight: FontWeight.bold,
            color: typeColor,
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText("Filter & Sort", size: 22, weight: FontWeight.bold),
                    TextButton(
                      onPressed: () {
                        controller.resetFilters();
                        Get.back();
                      },
                      child: AppText("Reset", color: colorScheme.primary),
                    ),
                  ],
                ),
                24.hBox,

                AppText("Transaction Type", size: 16, weight: FontWeight.w600),
                12.hBox,
                Obx(
                  () => Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: ['all', 'income', 'expense'].map((type) {
                      final isSelected = controller.selectedType.value == type;
                      return ChoiceChip(
                        label: AppText(type.capitalizeFirst!),
                        selected: isSelected,
                        onSelected: (_) {
                          controller.selectedType.value = type;
                          controller.applyFiltersAndSort();
                        },
                        selectedColor: colorScheme.primary,
                        backgroundColor: colorScheme.surface.withValues(
                          alpha: 0.7,
                        ),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                            color: isSelected
                                ? colorScheme.primary
                                : Colors.transparent,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                32.hBox,

                AppText("Sort By", size: 16, weight: FontWeight.w600),
                12.hBox,
                Obx(
                  () => Wrap(
                    spacing: 12,
                    runSpacing: 8,
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
                            label: AppText(item['label']!),
                            selected: isSelected,
                            onSelected: (_) {
                              controller.selectedSort.value =
                                  item['value'] as String;
                              controller.applyFiltersAndSort();
                            },
                            selectedColor: colorScheme.primary,
                            backgroundColor: colorScheme.surface.withValues(
                              alpha: 0.7,
                            ),
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          );
                        }).toList(),
                  ),
                ),

                32.hBox,

                AppText("Category", size: 16, weight: FontWeight.w600),
                12.hBox,
                Obx(
                  () => DropdownButtonFormField<String>(
                    initialValue: controller.selectedCategory.value,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Get.isDarkMode
                          ? colorScheme.surface.withValues(alpha: 0.3)
                          : null,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    dropdownColor: theme.cardColor,
                    items: controller.categories.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: AppText(cat == 'all' ? 'All Categories' : cat),
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

                40.hBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
