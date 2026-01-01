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

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text("Categories"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          final addCategoryController = Get.find<AddCategoryController>();
          addCategoryController.clearEditing();
          Screen.open(AddCategoryView(), binding: AddCategoryBinding());
        },
        child: const Icon(Icons.add, size: 28),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.categories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                16.hBox,
                AppText(
                  "No categories yet",
                  size: 18,
                  weight: FontWeight.w600,
                  color: textTheme.titleMedium?.color,
                ),
                8.hBox,
                AppText(
                  "Tap + to create your first category",
                  size: 14,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          );
        }

        return ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    "All Categories",
                    size: 20,
                    weight: FontWeight.bold,
                    color: textTheme.titleLarge?.color,
                  ),
                  AppText.click(
                    "Chart",
                    onTap: () {
                      Screen.open(
                        CategoriesChartView(),
                        binding: CategoriesChartBinding(),
                      );
                    },
                    size: 18,
                    color: colorScheme.primary,
                    weight: FontWeight.w600,
                  ),
                ],
              ),
            ),

            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.categories.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                final isIncome = category.type == 'income';

                final Color typeColor = isIncome ? Colors.green : Colors.red;
                final Color bgTint = isIncome
                    ? Colors.green.withValues(alpha: isDark ? 0.15 : 0.1)
                    : Colors.red.withValues(alpha: isDark ? 0.15 : 0.1);

                return Dismissible(
                  key: Key(category.id.toString()),
                  direction: DismissDirection.endToStart,
                  dismissThresholds: const {DismissDirection.endToStart: 0.5},
                  confirmDismiss: (direction) async {
                    return category.id != null
                        ? await _showDeleteDialog(context, category.id!)
                        : false;
                  },
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.3 : 0.08,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: bgTint,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isIncome
                              ? Icons.arrow_downward_rounded
                              : Icons.arrow_upward_rounded,
                          color: typeColor,
                        ),
                      ),
                      title: AppText(
                        category.name.capitalizeFirst ?? category.name,
                        size: 16,
                        weight: FontWeight.w600,
                        color: textTheme.bodyLarge?.color,
                      ),
                      subtitle: AppText(
                        isIncome ? 'Income' : 'Expense',

                        size: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        weight: FontWeight.w500,
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          final addCategoryController =
                              Get.find<AddCategoryController>();
                          addCategoryController.setEditingCategory(category);
                          Screen.open(
                            AddCategoryView(),
                            binding: AddCategoryBinding(),
                          );
                        },
                        icon: Icon(
                          Icons.edit,
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      }),
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context, int id) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: theme.cardColor,
        title: AppText(
          "Delete Category",
          weight: FontWeight.w700,
          color: theme.textTheme.titleLarge?.color,
        ),
        content: AppText(
          "Are you sure you want to delete this category?\nThis action cannot be undone.",
          color: colorScheme.onSurface.withValues(alpha: 0.8),
          size: 15,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: AppText(
              "Cancel",
              color: colorScheme.primary,
              weight: FontWeight.w600,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            onPressed: () {
              Get.find<AddCategoryController>().deleteCategory(id);
              // Navigator.pop(context, true);
              Screen.close(result: true);
            },
            child: const AppText("Delete", weight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
