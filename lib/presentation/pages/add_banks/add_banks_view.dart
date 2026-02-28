import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/presentation/controllers/add_banks/add_banks_controller.dart';

class AddBanksView extends GetView<AddBanksController> {
  const AddBanksView({super.key});

  // ── Type chip data
  static const _types = [
    {'key': 'savings', 'icon': Icons.savings_rounded, 'label': 'Savings'},
    {'key': 'credit', 'icon': Icons.credit_card_rounded, 'label': 'Credit'},
    {
      'key': 'debit',
      'icon': Icons.account_balance_wallet_rounded,
      'label': 'Debit',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final isDark = Get.isDarkMode;

    return Scaffold(
      body: Column(
        children: [
          // ── Fixed Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              bottom: 28,
              left: 24,
              right: 24,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E1B4B), const Color(0xFF0F172A)]
                    : [Colors.deepPurple.shade600, Colors.deepPurple.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withValues(
                    alpha: isDark ? 0.3 : 0.2,
                  ),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Obx(
                      () => Text(
                        controller.isEditing.value
                            ? "Edit Bank / Card"
                            : "Add Bank / Card",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // invisible placeholder for centering
                    const SizedBox(width: 34),
                  ],
                ),
                20.hBox,
                // Decorative icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_card_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                12.hBox,
                Text(
                  "Fill in the details below",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // ── Scrollable Form
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Bank Name
                  _buildLabel("Bank / Card Name"),
                  8.hBox,
                  _buildTextField(
                    context: context,
                    controller: controller.nameController,
                    hint: "e.g., HDFC Savings, Amex Credit",
                    icon: Icons.account_balance_rounded,
                    capitalization: TextCapitalization.words,
                  ),
                  28.hBox,

                  // ── Account Type (chips)
                  _buildLabel("Account Type"),
                  12.hBox,
                  Obx(
                    () => Row(
                      children: _types.map((t) {
                        final key = t['key'] as String;
                        final icon = t['icon'] as IconData;
                        final label = t['label'] as String;
                        final isSelected = controller.selectedType.value == key;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => controller.selectedType.value = key,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: EdgeInsets.only(
                                right: key != 'debit' ? 10 : 0,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? colorScheme.primary.withValues(
                                        alpha: isDark ? 0.25 : 0.1,
                                      )
                                    : theme.cardColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? colorScheme.primary
                                      : (isDark
                                            ? Colors.grey.shade700
                                            : Colors.grey.shade300),
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: colorScheme.primary.withValues(
                                            alpha: 0.15,
                                          ),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    icon,
                                    size: 24,
                                    color: isSelected
                                        ? colorScheme.primary
                                        : colorScheme.onSurface.withValues(
                                            alpha: 0.5,
                                          ),
                                  ),
                                  8.hBox,
                                  Text(
                                    label,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? colorScheme.primary
                                          : colorScheme.onSurface.withValues(
                                              alpha: 0.6,
                                            ),
                                    ),
                                  ),
                                  if (isSelected) ...[
                                    6.hBox,
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  28.hBox,

                  // ── Card Number
                  _buildLabel("Card / Account Number (Last 4 digits)"),
                  8.hBox,
                  _buildTextField(
                    context: context,
                    controller: controller.cardNumberController,
                    hint: "1234",
                    icon: Icons.credit_card_outlined,
                    keyboardType: TextInputType.number,
                    formatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    prefix: "•••• •••• •••• ",
                  ),
                  28.hBox,

                  // ── Opening Balance
                  _buildLabel("Opening Balance"),
                  8.hBox,
                  _buildTextField(
                    context: context,
                    controller: controller.balanceController,
                    hint: "0.00",
                    icon: Icons.account_balance_wallet_outlined,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    prefix: "₹ ",
                  ),
                  40.hBox,

                  // ── Save Button
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: controller.isSaving.value
                            ? null
                            : controller.saveBank,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: controller.isSaving.value ? 0 : 4,
                        ),
                        child: controller.isSaving.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    controller.isEditing.value
                                        ? Icons.check_circle_outline_rounded
                                        : Icons.add_circle_outline_rounded,
                                    size: 22,
                                  ),
                                  10.wBox,
                                  Text(
                                    controller.isEditing.value
                                        ? "Update Bank / Card"
                                        : "Save Bank / Card",
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),

                  16.hBox,

                  // ── Cancel / secondary button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Reusable label ─────────────────────────────────────────────────
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Get.theme.colorScheme.onSurface.withValues(alpha: 0.7),
        letterSpacing: 0.3,
      ),
    );
  }

  // ─── Reusable text field ────────────────────────────────────────────
  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    TextCapitalization capitalization = TextCapitalization.none,
    List<TextInputFormatter>? formatters,
    String? prefix,
  }) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final isDark = Get.isDarkMode;

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: capitalization,
      inputFormatters: formatters,
      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.35),
        ),
        prefixIcon: Container(
          margin: const EdgeInsets.only(left: 12, right: 8),
          child: Icon(
            icon,
            size: 20,
            color: colorScheme.primary.withValues(alpha: 0.7),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 44,
        ),
        prefixText: prefix,
        prefixStyle: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        filled: true,
        fillColor: isDark
            ? colorScheme.secondaryContainer.withValues(alpha: 0.2)
            : colorScheme.secondaryContainer.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
      ),
    );
  }
}
