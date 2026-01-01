import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/data/models/bank_model.dart';
import 'package:test_app/data/models/category_model.dart';
import 'package:test_app/presentation/controllers/add_transaction/add_transaction_controller.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

class AddTransactionView extends GetView<AddTransactionController> {
  const AddTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const AppText("Add Transaction", size: 22),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Amount Field
                    const AppText("Amount", size: 14, weight: FontWeight.w600),
                    8.hBox,
                    TextField(
                      controller: controller.amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Enter amount",
                        prefixIcon: const Icon(Icons.attach_money),
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                    24.hBox,

                    // Date Picker
                    const AppText("Date", size: 14, weight: FontWeight.w600),
                    8.hBox,
                    GestureDetector(
                      onTap: () => controller.pickDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: theme.cardColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                                12.wBox,
                                AppText(
                                  controller.selectedDate.value != null
                                      ? controller.getFormattedDate(
                                          controller.selectedDate.value!,
                                        )
                                      : "Select Date",
                                  color: controller.selectedDate.value != null
                                      ? textTheme.bodyLarge?.color
                                      : Colors.grey.shade600,
                                  size: 16,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    24.hBox,

                    // Category Dropdown
                    const AppText(
                      "Category",
                      size: 14,
                      weight: FontWeight.w600,
                    ),
                    8.hBox,
                    Obx(
                      () => DropdownButtonFormField<CategoryModel>(
                        value: controller.selectedCategory.value,
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
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        hint: const AppText(
                          "Select Category",
                          color: Colors.grey,
                        ),
                        dropdownColor: theme.cardColor,
                        items: controller.categories
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: AppText(
                                  "${category.name} (${category.type.capitalize})",
                                  color: textTheme.bodyLarge?.color,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedCategory.value = value;
                          }
                        },
                      ),
                    ),
                    24.hBox,

                    // Bank Dropdown
                    const AppText(
                      "Bank/Account",
                      size: 14,
                      weight: FontWeight.w600,
                    ),
                    8.hBox,
                    Obx(
                      () => DropdownButtonFormField<BankModel>(
                        value: controller.selectedBank.value,
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
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        hint: const AppText("Select Bank", color: Colors.grey),
                        dropdownColor: theme.cardColor,
                        items: controller.banks
                            .map(
                              (bank) => DropdownMenuItem(
                                value: bank,
                                child: AppText(
                                  "${bank.name} (${bank.type.capitalize})",
                                  color: textTheme.bodyLarge?.color,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedBank.value = value;
                          }
                        },
                      ),
                    ),
                    24.hBox,

                    // Notes Field
                    const AppText("Notes", size: 14, weight: FontWeight.w600),
                    8.hBox,
                    TextField(
                      controller: controller.notesController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Add notes (optional)",
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                      ),
                    ),
                    32.hBox,

                    // Save Button - Now fully uses AppTheme's ElevatedButton style
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: controller.saveTransaction,
                        child: const AppText(
                          "Save Transaction",
                          size: 16,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
