import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/presentation/controllers/add_category/add_category_controller.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

enum CategoryType { income, expense }

class AddCategoryView extends GetView<AddCategoryController> {
  const AddCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const AppText("Categories", size: 22)),
      body: Column(
        children: [
          // Add/Edit Form
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Obx(
                  () => AppText(
                    controller.editingCategory.value == null
                        ? "Add New Category"
                        : "Edit Category",
                    size: 24,
                    weight: FontWeight.bold,
                    color: textTheme.titleLarge?.color,
                  ),
                ),
                16.hBox,
                // Name TextField
                TextField(
                  controller: controller.categoryNameController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: "Category Name",
                    hintText: "e.g., Salary, Food, Rent",
                    prefixIcon: const Icon(Icons.category_outlined),
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
                    filled: true,
                    fillColor: isDark
                        ? colorScheme.surface.withValues(alpha: 0.3)
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
                16.hBox,
                // Type Radio Group
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText("Type", size: 16, weight: FontWeight.w600),
                      RepaintBoundary(
                        child: RadioGroup<CategoryType>(
                          groupValue: controller.character.value,

                          onChanged: (value) {
                            controller.setCharacter(value);
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: RadioListTile<CategoryType>(
                                  dense: true,
                                  title: const AppText("Income"),
                                  value: CategoryType.income,
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<CategoryType>(
                                  dense: true,
                                  title: const AppText("Expense"),
                                  value: CategoryType.expense,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                16.hBox,
                // Action Buttons
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (controller.editingCategory.value == null) {
                              controller.addCategory();
                            } else {
                              controller.updateCategory(
                                controller.editingCategory.value!,
                              );
                            }
                          },
                          child: AppText(
                            controller.editingCategory.value == null
                                ? "Add Category"
                                : "Update Category",
                            size: 16,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (controller.editingCategory.value != null) ...[
                        8.wBox,
                        Expanded(
                          child: OutlinedButton(
                            onPressed: controller.clearEditing,
                            child: const AppText(
                              "Cancel",
                              size: 16,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
