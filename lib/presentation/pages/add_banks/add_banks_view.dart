import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/presentation/controllers/add_banks/add_banks_controller.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

class AddBanksView extends GetView<AddBanksController> {
  const AddBanksView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = Get.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          "Add Bank / Card",
          size: 22,
          weight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bank Name
            AppText(
              "Bank / Card Name",
              size: 16,
              weight: FontWeight.w600,
              color: textTheme.titleMedium?.color,
            ),
            8.hBox,
            TextField(
              controller: controller.nameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: "e.g., HDFC Savings, Amex Credit",
                prefixIcon: const Icon(Icons.account_balance),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: isDark
                    ? colorScheme.surface.withValues(alpha: 0.3)
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            24.hBox,

            // Account Type
            AppText(
              "Account Type",
              size: 16,
              weight: FontWeight.w600,
              color: textTheme.titleMedium?.color,
            ),
            8.hBox,
            Obx(
              () => DropdownButtonFormField<String>(
                initialValue: controller.selectedType.value,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.credit_card),
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
                  fillColor: isDark
                      ? colorScheme.surface.withValues(alpha: 0.3)
                      : null,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                dropdownColor: theme.cardColor,
                hint: const Text("Select type"),
                items: ['savings', 'credit', 'debit']
                    .map(
                      (t) => DropdownMenuItem(
                        value: t,
                        child: Text(t.capitalize!),
                      ),
                    )
                    .toList(),
                onChanged: (v) => controller.selectedType.value = v!,
              ),
            ),
            24.hBox,

            // Card Number (Last 4 digits)
            AppText(
              "Card / Account Number (Last 4 digits optional)",
              size: 16,
              weight: FontWeight.w600,
              color: textTheme.titleMedium?.color,
            ),
            8.hBox,
            TextField(
              controller: controller.cardNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              decoration: InputDecoration(
                hintText: "•••• •••• •••• 1234",
                prefixIcon: const Icon(Icons.credit_card_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: isDark
                    ? colorScheme.surface.withValues(alpha: 0.3)
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            24.hBox,

            // Opening Balance
            AppText(
              "Opening Balance",
              size: 16,
              weight: FontWeight.w600,
              color: textTheme.titleMedium?.color,
            ),
            8.hBox,
            TextField(
              controller: controller.balanceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: "0.00",
                prefixText: "₹ ",
                prefixIcon: const Icon(Icons.account_balance_wallet),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: isDark
                    ? colorScheme.surface.withValues(alpha: 0.3)
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            40.hBox,

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: controller.isSaving.value
                    ? null
                    : controller.saveBank,
                child: controller.isSaving.value
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const AppText(
                        "Save Bank/Card",
                        size: 18,
                        weight: FontWeight.w600,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
