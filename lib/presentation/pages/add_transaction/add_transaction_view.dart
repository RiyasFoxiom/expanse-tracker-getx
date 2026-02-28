import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_app/presentation/controllers/add_transaction/add_transaction_controller.dart';

class AddTransactionView extends GetView<AddTransactionController> {
  const AddTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = Get.isDarkMode;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "New Transaction",
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CupertinoActivityIndicator(radius: 16))
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AMOUNT HEADER CARD
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "ENTER AMOUNT",
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
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "₹",
                                style: theme.textTheme.displayLarge?.copyWith(
                                  fontSize: 40,
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IntrinsicWidth(
                                child: TextField(
                                  controller: controller.amountController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  style: theme.textTheme.displayLarge?.copyWith(
                                    fontSize: 56,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -2,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: "0",
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    filled: false,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),

                    // DETAILS GROUP
                    Text(
                      "DETAILS",
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
                      child: Column(
                        children: [
                          // Date
                          _buildListRow(
                            context: context,
                            icon: CupertinoIcons.calendar,
                            iconColor: const Color(0xFFFF9500),
                            title: "Date",
                            valueText: controller.selectedDate.value != null
                                ? DateFormat(
                                    'MMM dd, yyyy',
                                  ).format(controller.selectedDate.value!)
                                : "Select Date",
                            onTap: () => controller.pickDate(context),
                            showDivider: true,
                          ),
                          // Category
                          _buildListRow(
                            context: context,
                            icon: CupertinoIcons.tag,
                            iconColor: const Color(0xFF34C759),
                            title: "Category",
                            valueText: controller.selectedCategory.value != null
                                ? controller.selectedCategory.value!.name
                                : "Select",
                            onTap: () => _showCategoryPicker(context),
                            showDivider: true,
                          ),
                          // Bank Account
                          _buildListRow(
                            context: context,
                            icon: CupertinoIcons.building_2_fill,
                            iconColor: const Color(0xFF007AFF),
                            title: "Account",
                            valueText: controller.selectedBank.value != null
                                ? controller.selectedBank.value!.name
                                : "Select",
                            onTap: () => _showBankPicker(context),
                            showDivider: true,
                          ),
                          // Notes
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF8E8E93,
                                    ).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.text_justify,
                                    color: Color(0xFF8E8E93),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextField(
                                    controller: controller.notesController,
                                    maxLines: 3,
                                    minLines: 1,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Add notes (optional)",
                                      hintStyle: TextStyle(
                                        fontSize: 17,
                                        color: isDark
                                            ? Colors.white54
                                            : Colors.grey.shade400,
                                      ),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                      filled: false,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: controller.saveTransaction,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Save Transaction",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildListRow({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String valueText,
    required VoidCallback onTap,
    required bool showDivider,
  }) {
    final theme = context.theme;
    final isDark = Get.isDarkMode;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    valueText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      color: valueText == "Select"
                          ? (isDark ? Colors.white54 : Colors.grey)
                          : theme.colorScheme.primary,
                      fontWeight: valueText == "Select"
                          ? FontWeight.w500
                          : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    CupertinoIcons.chevron_forward,
                    size: 18,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
            if (showDivider)
              Container(
                margin: const EdgeInsets.only(left: 52),
                height: 0.5,
                color: theme.dividerColor,
              ),
          ],
        ),
      ),
    );
  }

  void _showCategoryPicker(BuildContext context) {
    if (controller.categories.isEmpty) {
      Get.snackbar("No Categories", "Please add categories first.");
      return;
    }
    _showCupertinoBottomSheet(
      context: context,
      title: "Select Category",
      items: controller.categories,
      itemBuilder: (context, index) {
        final cat = controller.categories[index];
        return Center(
          child: Text(
            "${cat.name} (${cat.type.capitalizeFirst})",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: cat.type == 'income'
                  ? const Color(0xFF34C759)
                  : const Color(0xFFFF3B30),
            ),
          ),
        );
      },
      onSelect: (index) {
        controller.selectedCategory.value = controller.categories[index];
      },
    );
  }

  void _showBankPicker(BuildContext context) {
    if (controller.banks.isEmpty) {
      Get.snackbar("No Banks", "Please add a bank account first.");
      return;
    }
    _showCupertinoBottomSheet(
      context: context,
      title: "Select Account",
      items: controller.banks,
      itemBuilder: (context, index) {
        final bank = controller.banks[index];
        return Center(
          child: Text(
            "${bank.name} - ₹${bank.balance.toStringAsFixed(0)}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        );
      },
      onSelect: (index) {
        controller.selectedBank.value = controller.banks[index];
      },
    );
  }

  void _showCupertinoBottomSheet<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required Widget Function(BuildContext, int) itemBuilder,
    required void Function(int) onSelect,
  }) {
    final isDark = Get.isDarkMode;
    final theme = context.theme;
    int tempIndex = 0;

    showModalBottomSheet(
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
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                child: CupertinoPicker(
                  itemExtent: 48,
                  onSelectedItemChanged: (idx) {
                    tempIndex = idx;
                  },
                  children: List.generate(
                    items.length,
                    (index) => itemBuilder(context, index),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    onSelect(tempIndex);
                    Navigator.pop(context);
                  },
                  child: const Text("Select", style: TextStyle(fontSize: 17)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
