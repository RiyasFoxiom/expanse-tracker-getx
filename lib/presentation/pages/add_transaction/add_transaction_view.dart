import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/core/helpers/screen_helper.dart';
import 'package:test_app/presentation/controllers/add_transaction/add_transaction_controller.dart';
import 'package:test_app/presentation/widgets/app_dialogs.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

// ── Neo Brutalism tokens ─────────────────────────────────────────────────────
const _kAccentYellow = Color(0xFFFFE600);
const _kAccentGreen = Color(0xFF00C853);
const _kAccentRed = Color(0xFFFF1744);
const _kAccentBlue = Color(0xFF2979FF);
const _kAccentPurple = Color(0xFF7C4DFF);

class AddTransactionView extends GetView<AddTransactionController> {
  const AddTransactionView({super.key});

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
        toolbarHeight: 60,
        centerTitle: true,
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
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _kAccentYellow,
              border: .all(color: Colors.black, width: 2.5),
            ),
            child: const AppText(
              'NEW TRANSACTION',
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
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CupertinoActivityIndicator(radius: 16));
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const .fromLTRB(16, 24, 16, 32),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              // ── Amount Input Section ─────────────────────────────────────────
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const .symmetric(vertical: 16, horizontal: 16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        border: .all(color: Colors.black, width: 2.5),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(5, 5)),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: .center,
                        children: [
                          const AppText(
                            "₹",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: .w900,
                              color: _kAccentPurple,
                            ),
                          ),
                          12.wBox,
                          IntrinsicWidth(
                            child: TextField(
                              controller: controller.amountController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: .w900,
                                letterSpacing: -1,
                              ),
                              decoration: const InputDecoration(
                                hintText: "0",
                                border: .none,
                                focusedBorder: .none,
                                enabledBorder: .none,
                                errorBorder: .none,
                                disabledBorder: .none,
                                contentPadding: .zero,
                              ),
                              textAlign: .center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              20.hBox,

              // ── Transaction Details ──────────────────────────────────────────
              _nbLabel("TRANSACTION DETAILS", isDark),
              12.hBox,
              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  border: .all(color: Colors.black, width: 2.5),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    _nbListRow(
                      icon: CupertinoIcons.calendar,
                      iconColor: _kAccentYellow,
                      title: "DATE",
                      value: controller.selectedDate.value != null
                          ? DateFormat(
                              'MMM dd, yyyy',
                            ).format(controller.selectedDate.value!)
                          : "SELECT DATE",
                      onTap: () => controller.pickDate(context),
                      isDark: isDark,
                      showDivider: true,
                    ),
                    _nbListRow(
                      icon: CupertinoIcons.tag_fill,
                      iconColor: _kAccentGreen,
                      title: "CATEGORY",
                      value: controller.selectedCategory.value != null
                          ? controller.selectedCategory.value!.name
                                .toUpperCase()
                          : "SELECT CATEGORY",
                      onTap: () => _showCategoryPicker(context, isDark),
                      isDark: isDark,
                      showDivider: true,
                    ),
                    _nbListRow(
                      icon: CupertinoIcons.building_2_fill,
                      iconColor: _kAccentBlue,
                      title: "ACCOUNT",
                      value: controller.selectedBank.value != null
                          ? controller.selectedBank.value!.name.toUpperCase()
                          : "SELECT ACCOUNT",
                      onTap: () => _showBankPicker(context, isDark),
                      isDark: isDark,
                      showDivider: true,
                    ),
                    // Payback Toggle (Only for Expense)
                    Obx(() {
                      final isExpense =
                          controller.selectedCategory.value?.type == 'expense';
                      if (!isExpense) return const SizedBox.shrink();
                      return _nbToggleRow(
                        icon: CupertinoIcons.arrow_2_squarepath,
                        iconColor: _kAccentPurple,
                        title: "MARK FOR PAYBACK",
                        value: controller.isPayback.value,
                        onChanged: (val) => controller.isPayback.value = val,
                        isDark: isDark,
                        showDivider: true,
                      );
                    }),
                    // Notes Input
                    Padding(
                      padding: const .all(16),
                      child: Row(
                        crossAxisAlignment: .start,
                        children: [
                          Container(
                            padding: const .all(8),
                            decoration: BoxDecoration(
                              color: _kAccentPurple.withValues(alpha: 0.2),
                              border: .all(color: Colors.black, width: 2),
                            ),
                            child: const Icon(
                              CupertinoIcons.text_justify,
                              size: 18,
                              color: Colors.black,
                            ),
                          ),
                          16.wBox,
                          Expanded(
                            child: Padding(
                              padding: const .only(top: 0),
                              child: TextField(
                                controller: controller.notesController,
                                maxLines: 3,
                                minLines: 1,
                                style: const TextStyle(
                                  fontWeight: .w800,
                                  fontSize: 15,
                                ),
                                decoration: InputDecoration(
                                  hintText: "ADD NOTES (OPTIONAL)",
                                  hintStyle: TextStyle(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  border: .none,
                                  focusedBorder: .none,
                                  enabledBorder: .none,
                                  errorBorder: .none,
                                  disabledBorder: .none,
                                  contentPadding: .zero,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              30.hBox,

              // ── Action Buttons ───────────────────────────────────────────────
              GestureDetector(
                onTap: controller.saveTransaction,
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _kAccentBlue,
                    border: Border.all(color: Colors.black, width: 2.5),
                    boxShadow: const [
                      BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.checkmark_circle_fill,
                        color: Colors.white,
                        size: 24,
                      ),
                      12.wBox,
                      const AppText(
                        "SAVE TRANSACTION",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
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
                onTap: () => Screen.close(),
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
          ),
        );
      }),
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

  Widget _nbToggleRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Icon(icon, size: 18, color: Colors.black),
              ),
              16.wBox,
              AppText(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: _kAccentGreen,
                  trackColor: Colors.black12,
                ),
              ),
            ],
          ),
        ),
        if (showDivider) Container(height: 2, color: Colors.black),
      ],
    );
  }

  Widget _nbListRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required VoidCallback onTap,
    required bool isDark,
    required bool showDivider,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const .all(16),
            child: Row(
              children: [
                Container(
                  padding: const .all(8),
                  decoration: BoxDecoration(
                    color: iconColor,
                    border: .all(color: Colors.black, width: 2),
                  ),
                  child: Icon(icon, size: 18, color: Colors.black),
                ),
                16.wBox,
                AppText(
                  title,
                  style: const TextStyle(
                    fontWeight: .w900,
                    fontSize: 13,
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                AppText(
                  value,
                  style: TextStyle(
                    fontWeight: .w900,
                    fontSize: 14,
                    color: value.contains("SELECT")
                        ? Colors.black38
                        : _kAccentBlue,
                  ),
                ),
                8.wBox,
                const Icon(
                  CupertinoIcons.chevron_right,
                  size: 14,
                  color: Colors.black38,
                ),
              ],
            ),
          ),
        ),
        if (showDivider) Container(height: 2, color: Colors.black),
      ],
    );
  }

  void _showCategoryPicker(BuildContext context, bool isDark) {
    if (controller.categories.isEmpty) {
      AppDialogs.showSnackbar(
        message: "Please add categories first.",
        title: "No Categories",
        isError: true,
      );
      return;
    }
    _showNBModalPicker(
      context: context,
      title: "SELECT CATEGORY",
      items: controller.categories,
      itemBuilder: (context, index) {
        final cat = controller.categories[index];
        return Center(
          child: AppText(
            "${cat.name.toUpperCase()} (${cat.type.toUpperCase()})",
            style: TextStyle(
              fontSize: 18,
              fontWeight: .w900,
              color: cat.type == 'income' ? _kAccentGreen : _kAccentRed,
            ),
          ),
        );
      },
      onSelect: (index) {
        controller.selectedCategory.value = controller.categories[index];
      },
      isDark: isDark,
    );
  }

  void _showBankPicker(BuildContext context, bool isDark) {
    if (controller.banks.isEmpty) {
      AppDialogs.showSnackbar(
        message: "Please add a bank account first.",
        title: "No Banks",
        isError: true,
      );
      return;
    }
    _showNBModalPicker(
      context: context,
      title: "SELECT ACCOUNT",
      items: controller.banks,
      itemBuilder: (context, index) {
        final bank = controller.banks[index];
        return Center(
          child: AppText(
            "${bank.name.toUpperCase()} - ₹${bank.balance.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 18, fontWeight: .w900),
          ),
        );
      },
      onSelect: (index) {
        controller.selectedBank.value = controller.banks[index];
      },
      isDark: isDark,
    );
  }

  void _showNBModalPicker<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required Widget Function(BuildContext, int) itemBuilder,
    required void Function(int) onSelect,
    required bool isDark,
  }) {
    int tempIndex = 0;
    final bg = isDark ? const Color(0xFF1A1A1A) : Colors.white;

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: bg,
          border: const Border(top: BorderSide(color: Colors.black, width: 3)),
        ),
        padding: const .fromLTRB(20, 20, 20, 32),
        child: Column(
          mainAxisSize: .min,
          children: [
            Container(
              padding: const .symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _kAccentYellow,
                border: .all(color: Colors.black, width: 2),
              ),
              child: AppText(
                title,
                style: const TextStyle(
                  fontWeight: .w900,
                  fontSize: 16,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            24.hBox,
            SizedBox(
              height: 200,
              child: CupertinoPicker(
                itemExtent: 50,
                onSelectedItemChanged: (idx) => tempIndex = idx,
                children: List.generate(
                  items.length,
                  (i) => itemBuilder(context, i),
                ),
              ),
            ),
            24.hBox,
            GestureDetector(
              onTap: () {
                onSelect(tempIndex);
                Screen.close();
              },
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: .all(color: Colors.white, width: 1.5),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                  ],
                ),
                alignment: .center,
                child: const AppText(
                  "SELECT",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: .w900,
                    fontSize: 16,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
