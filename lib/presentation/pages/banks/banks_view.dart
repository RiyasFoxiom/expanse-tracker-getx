import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/core/helpers/screen_helper.dart';
import 'package:test_app/presentation/bindings/add_banks/add_banks_binding.dart';
import 'package:test_app/presentation/bindings/bank_transaction/bank_transaction_binding.dart';
import 'package:test_app/presentation/controllers/add_banks/add_banks_controller.dart';
import 'package:test_app/presentation/controllers/banks/banks_controller.dart';
import 'package:test_app/presentation/pages/add_banks/add_banks_view.dart';
import 'package:test_app/presentation/pages/bank_transaction/bank_transaction_view.dart';
import 'package:test_app/presentation/pages/banks/widget/card_widget.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

class BanksView extends GetView<BanksController> {
  const BanksView({super.key});

  // Theme-aware colors for different bank types
  Color _getTypeColor(String type) {
    final colorScheme = Get.context!.theme.colorScheme;
    final isDark = Get.context!.theme.brightness == Brightness.dark;

    switch (type.toLowerCase()) {
      case 'savings':
        return isDark ? Colors.green.shade300 : Colors.green.shade600;
      case 'credit':
        return isDark ? Colors.blue.shade300 : Colors.blue.shade700;
      case 'debit':
        return isDark ? Colors.orange.shade300 : Colors.orange.shade700;
      default:
        return colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final isDark = Get.isDarkMode;
    return Scaffold(
      appBar: AppBar(title: const Text("My Banks & Cards"), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Screen.open(const AddBanksView(), binding: AddBanksBinding()),
        child: const Icon(Icons.add_card),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.banks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 80,
                  color: Colors.grey.shade500,
                ),
                16.hBox,
                AppText(
                  "No banks or cards added yet",
                  size: 16,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                8.hBox,
                AppText(
                  "Tap + to add your first bank/card",
                  size: 14,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          separatorBuilder: (_, _) => 16.hBox,
          padding: const EdgeInsets.all(16),
          itemCount: controller.banks.length,
          itemBuilder: (_, i) {
            final bank = controller.banks[i];
            final typeColor = _getTypeColor(bank.type);
            return GestureDetector(
              onTap: () {
                Screen.open(
                  BankTransactionView(),
                  binding: BankTransactionBinding(bank),
                );
              },
              child: Slidable(
                key: ValueKey(i),
                endActionPane: ActionPane(
                  motion: DrawerMotion(),
                  children: [
                    SlidableAction(
                      flex: 2,
                      onPressed: (context) async {
                        final hasTx = await controller.repo.hasTransactions(
                          bank.id!,
                        );
                        final confirm = await showDialog<bool>(
                          context: Get.context!,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: const AppText("Delete Bank?"),
                            content: AppText(
                              hasTx
                                  ? "This bank has transactions. Delete anyway?"
                                  : "This bank will be permanently deleted.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const AppText("Cancel"),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const AppText(
                                  "Delete",
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await controller.deleteBank(bank.id!);
                        }
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete_outline_rounded,
                      label: 'Delete',
                    ),
                    SlidableAction(
                      flex: 2,
                      onPressed: (context) {
                        final addCtrl = Get.find<AddBanksController>();
                        addCtrl.setupForEdit(bank);
                        Screen.open(
                          const AddBanksView(),
                          binding: AddBanksBinding(),
                        );
                      },
                      backgroundColor: Color(0xFF0392CF),
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                  ],
                ),
                child: Card(
                  elevation: isDark ? 4 : 6,
                  margin: EdgeInsets.zero,
                  color: theme.cardColor,
                  shadowColor: typeColor.withValues(alpha: isDark ? 0.4 : 0.3),
                  surfaceTintColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: CardWidget(color: typeColor, bank: bank),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
