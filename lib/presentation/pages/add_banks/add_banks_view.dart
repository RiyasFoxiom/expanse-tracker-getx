import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/core/helpers/screen_helper.dart';
import 'package:test_app/presentation/controllers/add_banks/add_banks_controller.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

// ── Neo Brutalism tokens ─────────────────────────────────────────────────────
const _kAccentYellow = Color(0xFFFFE600);
const _kAccentGreen = Color(0xFF00C853);
const _kAccentBlue = Color(0xFF2979FF);
const _kAccentPurple = Color(0xFF7C4DFF);

class AddBanksView extends GetView<AddBanksController> {
  const AddBanksView({super.key});

  static const _types = [
    {
      'key': 'savings',
      'icon': CupertinoIcons.money_dollar_circle,
      'label': 'SAVINGS',
    },
    {'key': 'credit', 'icon': CupertinoIcons.creditcard, 'label': 'CREDIT'},
    {'key': 'debit', 'icon': CupertinoIcons.bag, 'label': 'DEBIT'},
    {'key': 'salary', 'icon': CupertinoIcons.briefcase, 'label': 'SALARY'},
  ];

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
        leading: GestureDetector(
          onTap: () => Screen.close(),
          child: Container(
            margin: const .all(10),
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
              size: 20,
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
            child: Obx(
              () => AppText(
                controller.isEditing.value ? "EDIT BANK" : "ADD BANK",
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 16,
                  fontWeight: .w900,
                  color: Colors.black,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const .fromLTRB(16, 24, 16, 32),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            // Bank Name
            _nbLabel("BANK / CARD NAME", isDark),
            12.hBox,
            _nbTextField(
              controller: controller.nameController,
              hint: "HDFC, AXIS, AMEX...",
              isDark: isDark,
              cardBg: cardBg,
              capitalization: .words,
            ),
            20.hBox,

            // Account Type
            _nbLabel("ACCOUNT TYPE", isDark),
            12.hBox,
            Obx(() {
              final selected = controller.selectedType.value;
              return Row(
                children: _types.map((t) {
                  final key = t['key'] as String;
                  final isSelected = selected == key;
                  return Expanded(
                    child: _nbTypeCard(
                      label: t['label'] as String,
                      icon: t['icon'] as IconData,
                      isSelected: isSelected,
                      onTap: () => controller.selectedType.value = key,
                      isDark: isDark,
                      cardBg: cardBg,
                    ),
                  );
                }).toList(),
              );
            }),
            20.hBox,

            // Card Number
            _nbLabel("CARD NUMBER (LAST 4)", isDark),
            12.hBox,
            _nbTextField(
              controller: controller.cardNumberController,
              hint: "1234",
              isDark: isDark,
              cardBg: cardBg,
              keyboardType: TextInputType.number,
              formatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              prefix: "•••• •••• •••• ",
            ),
            20.hBox,

            // Balance
            _nbLabel("OPENING BALANCE", isDark),
            12.hBox,
            _nbTextField(
              controller: controller.balanceController,
              hint: "0.00",
              isDark: isDark,
              cardBg: cardBg,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              prefix: "₹ ",
            ),
            48.hBox,

            // Save Button
            Obx(() {
              final isSaving = controller.isSaving.value;
              final isEditing = controller.isEditing.value;
              return Column(
                children: [
                  GestureDetector(
                    onTap: isSaving ? null : controller.saveBank,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: _kAccentBlue,
                        border: .all(color: Colors.black, width: 2.5),
                        boxShadow: isSaving
                            ? []
                            : const [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(4, 4),
                                ),
                              ],
                      ),
                      alignment: .center,
                      child: isSaving
                          ? const CupertinoActivityIndicator(
                              color: Colors.white,
                            )
                          : Row(
                              mainAxisAlignment: .center,
                              children: [
                                Icon(
                                  isEditing
                                      ? CupertinoIcons.check_mark_circled
                                      : CupertinoIcons.add_circled,
                                  color: Colors.white,
                                ),
                                12.wBox,
                                AppText(
                                  isEditing ? "UPDATE BANK" : "SAVE BANK",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: .w900,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  20.hBox,
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : Colors.black12,
                        border: .all(color: Colors.black, width: 2.5),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                        ],
                      ),
                      alignment: .center,
                      child: AppText(
                        "CANCEL",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: .w900,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
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

  Widget _nbTextField({
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    required Color cardBg,
    TextInputType? keyboardType,
    TextCapitalization capitalization = TextCapitalization.none,
    List<TextInputFormatter>? formatters,
    String? prefix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        border: .all(color: Colors.black, width: 2.5),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: capitalization,
        inputFormatters: formatters,
        style: const TextStyle(fontWeight: .w900, fontSize: 16),
        decoration: InputDecoration(
          hintText: hint.toUpperCase(),
          hintStyle: TextStyle(
            color: Colors.black.withValues(alpha: 0.3),
            fontSize: 14,
            fontWeight: .w700,
          ),
          prefixText: prefix,
          prefixStyle: const TextStyle(
            fontWeight: .w900,
            color: _kAccentPurple,
          ),
          border: .none,
          focusedBorder: .none,
          enabledBorder: .none,
          errorBorder: .none,
          disabledBorder: .none,
          contentPadding: const .symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _nbTypeCard({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
    required Color cardBg,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const .only(right: 8),
        padding: const .symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? _kAccentGreen : cardBg,
          border: .all(color: Colors.black, width: 2.5),
          boxShadow: isSelected
              ? const [BoxShadow(color: Colors.black, offset: Offset(4, 4))]
              : [],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white38 : Colors.black38),
            ),
            12.hBox,
            AppText(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: .w900,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white38 : Colors.black38),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
