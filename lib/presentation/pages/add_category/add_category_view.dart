import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/core/helpers/screen_helper.dart';
import 'package:test_app/presentation/controllers/add_category/add_category_controller.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

enum CategoryType { income, expense }

// ── Neo Brutalism tokens ─────────────────────────────────────────────────────
const _kAccentYellow = Color(0xFFFFE600);
const _kAccentGreen = Color(0xFF00C853);
const _kAccentRed = Color(0xFFFF1744);
const _kAccentBlue = Color(0xFF2979FF);

class AddCategoryView extends GetView<AddCategoryController> {
  const AddCategoryView({super.key});

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
        centerTitle: false,
        leading: GestureDetector(
          onTap: () => Screen.close(),
          child: Container(
            margin: const .only(left: 16, top: 10, bottom: 10),
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
                controller.editingCategory.value == null
                    ? 'NEW CATEGORY'
                    : 'EDIT CATEGORY',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
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
            // ── Category Name
            _nbLabel("CATEGORY NAME", isDark),
            12.hBox,
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                border: .all(color: Colors.black, width: 2.5),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                ],
              ),
              child: TextField(
                controller: controller.categoryNameController,
                textCapitalization: .sentences,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: "E.G., SALARY, FOOD, RENT",
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white38 : Colors.black26,
                    letterSpacing: 1,
                  ),
                  prefixIcon: const Icon(
                    CupertinoIcons.tag_fill,
                    size: 20,
                    color: Colors.black,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: const .symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),
            16.hBox,

            // ── Type Selector
            _nbLabel("CATEGORY TYPE", isDark),
            16.hBox,
            Obx(() {
              final selected = controller.character.value;
              return Row(
                children: [
                  Expanded(
                    child: _buildTypeCard(
                      label: "INCOME",
                      icon: CupertinoIcons.arrow_down_left,
                      color: _kAccentGreen,
                      isSelected: selected == .income,
                      onTap: () => controller.setCharacter(.income),
                      isDark: isDark,
                      cardBg: cardBg,
                    ),
                  ),
                  16.wBox,
                  Expanded(
                    child: _buildTypeCard(
                      label: "EXPENSE",
                      icon: CupertinoIcons.arrow_up_right,
                      color: _kAccentRed,
                      isSelected: selected == .expense,
                      onTap: () => controller.setCharacter(.expense),
                      isDark: isDark,
                      cardBg: cardBg,
                    ),
                  ),
                ],
              );
            }),
            30.hBox,

            // ── Save Button
            Obx(() {
              final isEditing = controller.editingCategory.value != null;
              return GestureDetector(
                onTap: () {
                  if (isEditing) {
                    controller.updateCategory(
                      controller.editingCategory.value!,
                    );
                  } else {
                    controller.addCategory();
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _kAccentBlue,
                    border: .all(color: Colors.black, width: 2.5),
                    boxShadow: const [
                      BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                    ],
                  ),
                  alignment: .center,
                  child: Row(
                    mainAxisAlignment: .center,
                    children: [
                      Icon(
                        isEditing
                            ? CupertinoIcons.check_mark_circled
                            : CupertinoIcons.add_circled,
                        color: Colors.white,
                        size: 24,
                      ),
                      12.wBox,
                      AppText(
                        isEditing ? "UPDATE CATEGORY" : "ADD CATEGORY",
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
              );
            }),
            16.hBox,

            // ── Cancel Button
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
      ),
    );
  }

  // ── Section Label ──────────────────────────────────────────────────────────
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
          fontSize: 13,
          fontWeight: .w900,
          letterSpacing: 1.5,
          color: isDark ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  // ─── Type Selection Card ────────────────────────────────────────────
  Widget _buildTypeCard({
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
    required Color cardBg,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const .symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color : cardBg,
          border: .all(color: Colors.black, width: 2.5),
          boxShadow: isSelected
              ? const [BoxShadow(color: Colors.black, offset: Offset(4, 4))]
              : [],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white38 : Colors.black38),
            ),
            6.hBox,
            AppText(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: .w900,
                letterSpacing: 1,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white54 : Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
