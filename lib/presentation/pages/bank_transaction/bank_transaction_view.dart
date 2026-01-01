import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/presentation/controllers/bank_transaction/bank_transaction_controller.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

class BankTransactionView extends GetView<BankTransactionController> {
  const BankTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = Get.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: AppText(
          "${controller.bank.name} Transactions",
          size: 22,
          weight: FontWeight.bold,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.transactions.isEmpty) {
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
                  "No transactions for this bank",
                  size: 18,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                8.hBox,
                AppText(
                  "Transactions will appear here once added",
                  size: 14,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          itemCount: controller.transactions.length,
          itemBuilder: (context, index) {
            final tx = controller.transactions[index];
            final bool isIncome = tx.type == 'income';

            final Color typeColor = isIncome ? Colors.green : Colors.red;
            final Color bgTint = typeColor.withValues(
              alpha: isDark ? 0.15 : 0.1,
            );

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                leading: CircleAvatar(
                  radius: 26,
                  backgroundColor: bgTint,
                  child: Icon(
                    isIncome
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                    color: typeColor,
                    size: 28,
                  ),
                ),
                title: AppText(
                  tx.category,
                  size: 17,
                  weight: FontWeight.w600,
                  color: textTheme.bodyLarge?.color,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: AppText(
                    DateFormat('dd MMM yyyy').format(tx.date),
                    size: 14,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                trailing: AppText(
                  "${isIncome ? '+' : '-'} ₹${tx.amount.toStringAsFixed(0)}",
                  size: 18,
                  weight: FontWeight.bold,
                  color: typeColor,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
