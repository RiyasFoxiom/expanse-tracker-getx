import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_app/presentation/controllers/bank_transaction/bank_transaction_controller.dart';

class BankTransactionView extends GetView<BankTransactionController> {
  const BankTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
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
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                controller.bank.name,
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

              if (controller.transactions.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          CupertinoIcons.building_2_fill,
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
                          "Transactions matched to this account\nwill appear here.",
                          style: TextStyle(
                            color: isDark
                                ? Colors.white54
                                : Colors.grey.shade500,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TRANSACTIONS HISTORY",
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
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
                        itemCount: controller.transactions.length,
                        separatorBuilder: (context, index) => Container(
                          margin: const EdgeInsets.only(left: 72),
                          height: 0.5,
                          color: theme.dividerColor,
                        ),
                        itemBuilder: (context, index) {
                          final tx = controller.transactions[index];
                          final isIncome = tx.type == 'income';
                          final accentColor = isIncome
                              ? const Color(0xFF34C759)
                              : const Color(0xFFFF3B30);

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: accentColor.withValues(
                                      alpha: isDark ? 0.2 : 0.1,
                                    ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tx.category,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat(
                                          'MMM dd, yyyy',
                                        ).format(tx.date),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: isDark
                                              ? Colors.white54
                                              : Colors.grey.shade600,
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
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
