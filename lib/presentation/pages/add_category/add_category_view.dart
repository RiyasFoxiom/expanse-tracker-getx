import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/presentation/controllers/add_category/add_category_controller.dart';

enum CategoryType { income, expense }

class AddCategoryView extends GetView<AddCategoryController> {
  const AddCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          // ── Fixed gradient header ──────────────────────────────────
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
                // Top bar
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
                        controller.editingCategory.value == null
                            ? "New Category"
                            : "Edit Category",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 34), // balance placeholder
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
                    Icons.category_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                10.hBox,
                Text(
                  "Organize your finances better",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // ── Scrollable form ───────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Category Name
                  _buildLabel("Category Name"),
                  10.hBox,
                  TextField(
                    controller: controller.categoryNameController,
                    textCapitalization: TextCapitalization.sentences,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: "e.g., Salary, Food, Rent",
                      hintStyle: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.35),
                      ),
                      prefixIcon: Container(
                        margin: const EdgeInsets.only(left: 12, right: 8),
                        child: Icon(
                          Icons.label_rounded,
                          size: 20,
                          color: colorScheme.primary.withValues(alpha: 0.7),
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 44,
                      ),
                      filled: true,
                      fillColor: isDark
                          ? colorScheme.secondaryContainer.withValues(
                              alpha: 0.2,
                            )
                          : colorScheme.secondaryContainer.withValues(
                              alpha: 0.3,
                            ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                    ),
                  ),
                  32.hBox,

                  // ── Type Selector
                  _buildLabel("Category Type"),
                  14.hBox,
                  Obx(() {
                    final selected = controller.character.value;
                    return Row(
                      children: [
                        // Income card
                        Expanded(
                          child: _buildTypeCard(
                            context: context,
                            label: "Income",
                            icon: Icons.trending_down_rounded,
                            color: const Color(0xFF22C55E),
                            isSelected: selected == CategoryType.income,
                            onTap: () =>
                                controller.setCharacter(CategoryType.income),
                          ),
                        ),
                        16.wBox,
                        // Expense card
                        Expanded(
                          child: _buildTypeCard(
                            context: context,
                            label: "Expense",
                            icon: Icons.trending_up_rounded,
                            color: const Color(0xFFEF4444),
                            isSelected: selected == CategoryType.expense,
                            onTap: () =>
                                controller.setCharacter(CategoryType.expense),
                          ),
                        ),
                      ],
                    );
                  }),
                  48.hBox,

                  // ── Save Button
                  Obx(() {
                    final isEditing = controller.editingCategory.value != null;
                    return Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepPurple.shade500,
                            Colors.deepPurple.shade800,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (isEditing) {
                            controller.updateCategory(
                              controller.editingCategory.value!,
                            );
                          } else {
                            controller.addCategory();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isEditing
                                  ? Icons.check_circle_outline_rounded
                                  : Icons.add_circle_outline_rounded,
                              size: 22,
                              color: Colors.white,
                            ),
                            10.wBox,
                            Text(
                              isEditing ? "Update Category" : "Add Category",
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  16.hBox,

                  // ── Cancel Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        side: BorderSide(
                          color: isDark ? Colors.white24 : Colors.black12,
                        ),
                      ),
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

  // ─── Label ──────────────────────────────────────────────────────────
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

  // ─── Type Selection Card ────────────────────────────────────────────
  Widget _buildTypeCard({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Get.isDarkMode;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: isDark ? 0.2 : 0.08)
              : context.theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? color
                : (isDark
                      ? Colors.white12
                      : Colors.black.withValues(alpha: 0.06)),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            // Icon circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: isDark ? 0.25 : 0.15)
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.grey.withValues(alpha: 0.08)),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 22,
                color: isSelected
                    ? color
                    : (isDark ? Colors.white38 : Colors.grey),
              ),
            ),
            12.hBox,
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? color
                    : (isDark ? Colors.white54 : Colors.grey.shade600),
              ),
            ),
            if (isSelected) ...[
              8.hBox,
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
