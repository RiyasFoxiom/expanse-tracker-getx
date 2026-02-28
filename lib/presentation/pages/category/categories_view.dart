import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/core/helpers/screen_helper.dart';
import 'package:test_app/presentation/bindings/add_category/add_category_binding.dart';
import 'package:test_app/presentation/bindings/categories_chart/categories_chart_binding.dart';
import 'package:test_app/presentation/controllers/add_category/add_category_controller.dart';
import 'package:test_app/presentation/controllers/categories/categories_controller.dart';
import 'package:test_app/presentation/pages/add_category/add_category_view.dart';
import 'package:test_app/presentation/pages/categories_chart/categories_chart_view.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({super.key});

  // ── Helpers ──────────────────────────────────────────────────────────
  int get _incomeCount =>
      controller.categories.where((c) => c.type == 'income').length;

  int get _expenseCount =>
      controller.categories.where((c) => c.type == 'expense').length;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: FloatingActionButton(
          onPressed: () {
            final addCtrl = Get.find<AddCategoryController>();
            addCtrl.clearEditing();
            Screen.open(AddCategoryView(), binding: AddCategoryBinding());
          },
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(Icons.add_rounded, size: 28),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // ── Fixed gradient header ────────────────────────────────
            _buildHeader(context, isDark, colorScheme),

            // ── Scrollable content ───────────────────────────────────
            Expanded(
              child: controller.categories.isEmpty
                  ? _buildEmptyState(colorScheme)
                  : _buildCategoryList(context, theme, colorScheme, isDark),
            ),
          ],
        );
      }),
    );
  }

  // ─── Header ─────────────────────────────────────────────────────────
  Widget _buildHeader(
    BuildContext context,
    bool isDark,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 24,
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
            color: Colors.deepPurple.withValues(alpha: isDark ? 0.3 : 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              const Text(
                "Categories",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              // Chart button
              GestureDetector(
                onTap: () => Screen.open(
                  CategoriesChartView(),
                  binding: CategoriesChartBinding(),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.pie_chart_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "Chart",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          20.hBox,
          // Stats row
          Row(
            children: [
              _buildStatPill(
                icon: Icons.arrow_downward_rounded,
                label: "$_incomeCount Income",
                color: const Color(0xFF4ADE80),
              ),
              12.wBox,
              _buildStatPill(
                icon: Icons.arrow_upward_rounded,
                label: "$_expenseCount Expense",
                color: const Color(0xFFFB7185),
              ),
              const Spacer(),
              Text(
                "${controller.categories.length} total",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          6.wBox,
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Empty State ────────────────────────────────────────────────────
  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.category_rounded,
              size: 56,
              color: colorScheme.primary.withValues(alpha: 0.5),
            ),
          ),
          24.hBox,
          AppText(
            "No categories yet",
            size: 18,
            weight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          8.hBox,
          AppText(
            "Tap + to create your first category",
            size: 14,
            color: colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }

  // ─── Category List ──────────────────────────────────────────────────
  Widget _buildCategoryList(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
      itemCount: controller.categories.length,
      itemBuilder: (context, index) {
        final category = controller.categories[index];
        final isIncome = category.type == 'income';

        final Color typeColor = isIncome
            ? const Color(0xFF22C55E)
            : const Color(0xFFEF4444);
        final Color softBg = typeColor.withValues(alpha: isDark ? 0.12 : 0.06);

        return Dismissible(
          key: Key(category.id.toString()),
          direction: DismissDirection.endToStart,
          dismissThresholds: const {DismissDirection.endToStart: 0.4},
          confirmDismiss: (_) async {
            return category.id != null
                ? await _showDeleteDialog(context, category.id!)
                : false;
          },
          background: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade400, Colors.red.shade700],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 28),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.white,
                  size: 26,
                ),
                SizedBox(height: 4),
                Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.04),
              ),
              boxShadow: [
                BoxShadow(
                  color: typeColor.withValues(alpha: isDark ? 0.08 : 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  final addCtrl = Get.find<AddCategoryController>();
                  addCtrl.setEditingCategory(category);
                  Screen.open(AddCategoryView(), binding: AddCategoryBinding());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      // Icon container
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: softBg,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          isIncome
                              ? Icons.trending_down_rounded
                              : Icons.trending_up_rounded,
                          color: typeColor,
                          size: 24,
                        ),
                      ),
                      16.wBox,
                      // Name + type
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.name.capitalizeFirst ?? category.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            4.hBox,
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: typeColor.withValues(
                                  alpha: isDark ? 0.18 : 0.1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isIncome ? 'Income' : 'Expense',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: typeColor,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Edit button
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.edit_rounded,
                          size: 18,
                          color: colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── Delete Dialog ──────────────────────────────────────────────────
  Future<bool?> _showDeleteDialog(BuildContext context, int id) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: theme.cardColor,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.red,
                size: 22,
              ),
            ),
            12.wBox,
            Text(
              "Delete Category",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to delete this category?\nThis action cannot be undone.",
          style: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(
                      color: isDark ? Colors.white24 : Colors.black12,
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
              12.wBox,
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Get.find<AddCategoryController>().deleteCategory(id);
                    Screen.close(result: true);
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
