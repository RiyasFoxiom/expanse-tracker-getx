import 'package:flutter/cupertino.dart';
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

// ── Neo Brutalism tokens ─────────────────────────────────────────────────────
const _kBorder = BorderSide(color: Colors.black, width: 2.5);
const _kAccentYellow = Color(0xFFFFE600);
const _kAccentGreen = Color(0xFF00C853);
const _kAccentRed = Color(0xFFFF1744);
const _kAccentBlue = Color(0xFF2979FF);
const _kAccentPurple = Color(0xFF7C4DFF);

class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({super.key});

  int get _incomeCount =>
      controller.categories.where((c) => c.type == 'income').length;
  int get _expenseCount =>
      controller.categories.where((c) => c.type == 'expense').length;

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
        title: Padding(
          padding: const .only(top: 8.0),
          child: Container(
            padding: const .symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _kAccentYellow,
              border: .all(color: Colors.black, width: 2.5),
            ),
            child: const AppText(
              'CATEGORIES',
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
        actions: [
          Padding(
            padding: const .only(top: 8.0, right: 16.0),
            child: GestureDetector(
              onTap: () {
                Screen.open(
                  const CategoriesChartView(),
                  binding: CategoriesChartBinding(),
                );
              },
              child: Container(
                padding: const .symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _kAccentPurple,
                  border: .all(color: Colors.black, width: 2.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(3, 3),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.pie_chart_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    AppText(
                      'CHART',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: .w900,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const .only(bottom: 80),
        child: GestureDetector(
          onTap: () {
            final addCtrl = Get.find<AddCategoryController>();
            addCtrl.clearEditing();
            Screen.open(const AddCategoryView(), binding: AddCategoryBinding());
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: _kAccentBlue,
              border: .fromBorderSide(_kBorder),
              boxShadow: [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 32),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CupertinoActivityIndicator(radius: 16));
        }

        return CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const .symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    // Stats Header Row
                    Row(
                      children: [
                        _buildStatPill(
                          icon: CupertinoIcons.arrow_down_left,
                          label: "$_incomeCount INCOME",
                          color: _kAccentGreen,
                        ),
                        12.wBox,
                        _buildStatPill(
                          icon: CupertinoIcons.arrow_up_right,
                          label: "$_expenseCount EXPENSE",
                          color: _kAccentRed,
                        ),
                        const Spacer(),
                        AppText(
                          "${controller.categories.length} TOTAL",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: .w900,
                            color: isDark ? Colors.white54 : Colors.black54,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    24.hBox,
                    if (controller.categories.isEmpty)
                      _buildEmptyState(isDark, cardBg)
                    else
                      Container(
                        decoration: BoxDecoration(
                          color: cardBg,
                          border: const .fromBorderSide(_kBorder),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(5, 5),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: .zero,
                          itemCount: controller.categories.length,
                          separatorBuilder: (context, index) =>
                              Container(height: 2.5, color: Colors.black),
                          itemBuilder: (context, index) {
                            final category = controller.categories[index];
                            return _buildCategoryRow(
                              context,
                              category,
                              isDark,
                              cardBg,
                            );
                          },
                        ),
                      ),
                    120.hBox,
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // ── Stat Pill ─────────────────────────────────────────────────────────────
  Widget _buildStatPill({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const .symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        border: .all(color: Colors.black, width: 2),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          6.wBox,
          AppText(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty State ────────────────────────────────────────────────────────────
  Widget _buildEmptyState(bool isDark, Color cardBg) {
    return Center(
      child: Padding(
        padding: const .symmetric(vertical: 40),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Container(
              padding: const .all(20),
              decoration: BoxDecoration(
                color: cardBg,
                border: .all(color: Colors.black, width: 2.5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(5, 5),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Icon(
                CupertinoIcons.square_grid_2x2,
                size: 50,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
            ),
            16.hBox,
            AppText(
              'NO CATEGORIES YET.',
              align: .center,
              style: TextStyle(
                fontWeight: .w900,
                fontSize: 14,
                letterSpacing: 1,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
            8.hBox,
            AppText(
              'TAP + TO CREATE ONE.',
              align: .center,
              style: TextStyle(
                fontWeight: .w700,
                fontSize: 12,
                letterSpacing: 0.5,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Category Row ───────────────────────────────────────────────────────────
  Widget _buildCategoryRow(
    BuildContext context,
    dynamic category,
    bool isDark,
    Color cardBg,
  ) {
    final isIncome = category.type == 'income';
    final accentColor = isIncome ? _kAccentGreen : _kAccentRed;

    return Dismissible(
      key: ValueKey(category.id),
      direction: .endToStart,
      confirmDismiss: (_) async {
        return category.id != null
            ? await _showDeleteDialog(context, category.id!)
            : false;
      },
      background: Container(
        padding: const .only(right: 20),
        alignment: .centerRight,
        color: _kAccentRed,
        child: const Icon(CupertinoIcons.trash, color: Colors.white, size: 24),
      ),
      child: Container(
        padding: const .symmetric(horizontal: 14, vertical: 14),
        color: cardBg,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              color: accentColor,
              child: Icon(
                isIncome
                    ? CupertinoIcons.arrow_down_left
                    : CupertinoIcons.arrow_up_right,
                color: Colors.white,
                size: 20,
              ),
            ),
            12.wBox,
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  AppText(
                    category.name.toString().toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: .w900,
                      letterSpacing: 0.5,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  4.hBox,
                  Container(
                    padding: const .symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.black12,
                      border: .all(
                        color: isDark ? Colors.white30 : Colors.black26,
                        width: 1.5,
                      ),
                    ),
                    child: AppText(
                      isIncome ? 'INCOME' : 'EXPENSE',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: .w900,
                        color: accentColor,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                final addCtrl = Get.find<AddCategoryController>();
                addCtrl.setEditingCategory(category);
                Screen.open(
                  const AddCategoryView(),
                  binding: AddCategoryBinding(),
                );
              },
              child: Container(
                padding: const .all(8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white : Colors.black,
                ),
                child: Icon(
                  Icons.edit_rounded,
                  size: 20,
                  color: isDark ? Colors.black : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Delete Dialog ──────────────────────────────────────────────────────────
  Future<bool?> _showDeleteDialog(BuildContext context, int id) {
    final isDark = Theme.of(context).brightness == .dark;
    final bg = isDark ? const Color(0xFF1A1A1A) : Colors.white;

    return showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const .all(24),
        child: Container(
          padding: const .all(24),
          decoration: BoxDecoration(
            color: bg,
            border: .all(color: Colors.black, width: 2.5),
            boxShadow: const [
              BoxShadow(color: Colors.black, offset: Offset(6, 6)),
            ],
          ),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              Container(
                padding: const .symmetric(horizontal: 10, vertical: 4),
                color: _kAccentRed,
                child: const AppText(
                  "DELETE CATEGORY",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: .w900,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              24.hBox,
              AppText(
                "ARE YOU SURE YOU WANT TO DELETE THIS CATEGORY? THIS ACTION CANNOT BE UNDONE.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: .w700,
                  color: isDark ? Colors.white : Colors.black,
                  height: 1.5,
                ),
              ),
              32.hBox,
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Screen.close(result: false),
                      child: Container(
                        padding: const .symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey.shade800
                              : Colors.grey.shade300,
                          border: .all(color: Colors.black, width: 2.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(3, 3),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: AppText(
                          "CANCEL",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: .w900,
                            color: isDark ? Colors.white : Colors.black,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  16.wBox,
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.find<AddCategoryController>().deleteCategory(id);
                        Screen.close(result: true);
                      },
                      child: Container(
                        padding: const .symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _kAccentRed,
                          border: .all(color: Colors.black, width: 2.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(3, 3),
                            ),
                          ],
                        ),
                        alignment: .center,
                        child: const AppText(
                          "DELETE",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: .w900,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
