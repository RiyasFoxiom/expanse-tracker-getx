import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/core/helpers/screen_helper.dart';
import 'package:test_app/data/models/bank_model.dart';
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

  // ─── Helpers ────────────────────────────────────────────────────────
  Color _getTypeColor(String type) {
    final isDark = Get.isDarkMode;
    switch (type.toLowerCase()) {
      case 'savings':
        return isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A);
      case 'credit':
        return isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB);
      case 'debit':
        return isDark ? const Color(0xFFFB923C) : const Color(0xFFEA580C);
      default:
        return isDark ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED);
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'savings':
        return Icons.savings_outlined;
      case 'credit':
        return Icons.credit_card;
      case 'debit':
        return Icons.account_balance_wallet_outlined;
      default:
        return Icons.account_balance;
    }
  }

  double _getTotalBalance() {
    double total = 0;
    for (final b in controller.banks) {
      total += b.balance;
    }
    return total;
  }

  // ─── Transfer Bottom Sheet ──────────────────────────────────────────
  void _showTransferSheet(BuildContext context) {
    if (controller.banks.length < 2) {
      Get.snackbar(
        'Not Enough Banks',
        'You need at least 2 banks to make a transfer',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
      );
      return;
    }

    final amountCtrl = TextEditingController();
    final Rx<BankModel?> fromBank = Rx(null);
    final Rx<BankModel?> toBank = Rx(null);

    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // ── Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple.shade400,
                          Colors.deepPurple.shade700,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.swap_horiz_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  12.wBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Transfer Funds",
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Move money between accounts",
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.close,
                      color: context.theme.colorScheme.onSurface.withValues(
                        alpha: 0.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // ── Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // From bank
                    Text(
                      "From",
                      style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    8.hBox,
                    Obx(
                      () => _buildBankSelector(context, fromBank, toBank.value),
                    ),
                    20.hBox,
                    // Swap icon
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: context.theme.colorScheme.primaryContainer
                              .withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_downward_rounded,
                          size: 20,
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    20.hBox,
                    // To bank
                    Text(
                      "To",
                      style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    8.hBox,
                    Obx(
                      () => _buildBankSelector(context, toBank, fromBank.value),
                    ),
                    24.hBox,
                    // Amount
                    Text(
                      "Amount",
                      style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    8.hBox,
                    TextField(
                      controller: amountCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: '0.00',
                        prefixText: '₹ ',
                        prefixStyle: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.primary,
                        ),
                        filled: true,
                        fillColor: context.theme.colorScheme.secondaryContainer
                            .withValues(alpha: 0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: context.theme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                      ),
                    ),
                    28.hBox,
                    // Confirm button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          if (fromBank.value == null || toBank.value == null) {
                            Get.snackbar(
                              'Select Banks',
                              'Please select both source and destination banks',
                              snackPosition: SnackPosition.BOTTOM,
                              margin: const EdgeInsets.all(16),
                              borderRadius: 16,
                            );
                            return;
                          }
                          final amount = double.tryParse(amountCtrl.text) ?? 0;
                          if (amount <= 0) {
                            Get.snackbar(
                              'Invalid Amount',
                              'Enter a valid transfer amount',
                              snackPosition: SnackPosition.BOTTOM,
                              margin: const EdgeInsets.all(16),
                              borderRadius: 16,
                            );
                            return;
                          }
                          controller.transferFunds(
                            fromBank.value!.id!,
                            toBank.value!.id!,
                            amount,
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send_rounded, size: 20),
                            SizedBox(width: 10),
                            Text(
                              "Transfer Now",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    16.hBox,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enterBottomSheetDuration: const Duration(milliseconds: 300),
      exitBottomSheetDuration: const Duration(milliseconds: 200),
    );
  }

  Widget _buildBankSelector(
    BuildContext context,
    Rx<BankModel?> selected,
    BankModel? excluded,
  ) {
    final isDark = Get.isDarkMode;
    final available = controller.banks
        .where((b) => b.id != excluded?.id)
        .toList();
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: available.length,
        separatorBuilder: (_, _) => 10.wBox,
        itemBuilder: (_, i) {
          final bank = available[i];
          final isSelected = selected.value?.id == bank.id;
          final typeColor = _getTypeColor(bank.type);
          return GestureDetector(
            onTap: () => selected.value = bank,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 150,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? typeColor.withValues(alpha: isDark ? 0.25 : 0.1)
                    : context.theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? typeColor
                      : Colors.grey.withValues(alpha: 0.2),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: typeColor.withValues(alpha: 0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(_getTypeIcon(bank.type), size: 16, color: typeColor),
                      6.wBox,
                      Expanded(
                        child: Text(
                          bank.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: context.theme.colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isSelected)
                        Icon(Icons.check_circle, size: 16, color: typeColor),
                    ],
                  ),
                  6.hBox,
                  Text(
                    "₹${bank.balance.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: typeColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── Delete confirmation ────────────────────────────────────────────
  Future<void> _confirmDelete(BuildContext context, BankModel bank) async {
    final hasTx = await controller.repo.hasTransactions(bank.id!);
    final theme = context.theme;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 20,
              ),
            ),
            12.wBox,
            const Text(
              "Delete Bank?",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          hasTx
              ? "This bank has transactions. Delete anyway?"
              : "This bank will be permanently deleted.",
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(100, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              "Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) await controller.deleteBank(bank.id!);
  }

  // ─── Build ──────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final isDark = Get.isDarkMode;

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // ── Fixed Header (never scrolls)
            Container(
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
                      : [
                          Colors.deepPurple.shade600,
                          Colors.deepPurple.shade900,
                        ],
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar
                  Row(
                    children: [
                      const Text(
                        "My Banks & Cards",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          if (Get.isRegistered<AddBanksController>()) {
                            Get.find<AddBanksController>().resetForAdd();
                          }
                          Screen.open(
                            const AddBanksView(),
                            binding: AddBanksBinding(),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  28.hBox,
                  // Total balance
                  Text(
                    "Total Balance",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  6.hBox,
                  Text(
                    "₹${_getTotalBalance().toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  6.hBox,
                  Text(
                    "${controller.banks.length} account${controller.banks.length != 1 ? 's' : ''}",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 13,
                    ),
                  ),
                  20.hBox,
                  // Quick actions
                  Row(
                    children: [
                      _buildQuickAction(
                        icon: Icons.swap_horiz_rounded,
                        label: "Transfer",
                        onTap: () => _showTransferSheet(context),
                      ),
                      12.wBox,
                      _buildQuickAction(
                        icon: Icons.add_card_rounded,
                        label: "Add Bank",
                        onTap: () {
                          if (Get.isRegistered<AddBanksController>()) {
                            Get.find<AddBanksController>().resetForAdd();
                          }
                          Screen.open(
                            const AddBanksView(),
                            binding: AddBanksBinding(),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Scrollable content below
            Expanded(
              child: controller.banks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer.withValues(
                                alpha: 0.3,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 56,
                              color: colorScheme.primary.withValues(alpha: 0.5),
                            ),
                          ),
                          24.hBox,
                          AppText(
                            "No banks or cards yet",
                            size: 18,
                            weight: FontWeight.w600,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                          8.hBox,
                          AppText(
                            "Tap '+' or 'Add Bank' to get started",
                            size: 14,
                            color: colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                      itemCount:
                          controller.banks.length + 1, // +1 for section header
                      itemBuilder: (context, index) {
                        // Section header
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                            child: Row(
                              children: [
                                Text(
                                  "Your Accounts",
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "Swipe for actions →",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final bank = controller.banks[index - 1];
                        final typeColor = _getTypeColor(bank.type);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: GestureDetector(
                            onTap: () => Screen.open(
                              BankTransactionView(),
                              binding: BankTransactionBinding(bank),
                            ),
                            child: Slidable(
                              key: ValueKey(bank.id),
                              endActionPane: ActionPane(
                                motion: const StretchMotion(),
                                extentRatio: 0.5,
                                children: [
                                  SlidableAction(
                                    flex: 1,
                                    onPressed: (_) {
                                      Screen.open(
                                        const AddBanksView(),
                                        binding: AddBanksBinding(),
                                      );
                                      // setupForEdit after push so the controller exists
                                      if (Get.isRegistered<
                                        AddBanksController
                                      >()) {
                                        Get.find<AddBanksController>()
                                            .setupForEdit(bank);
                                      }
                                    },
                                    backgroundColor: const Color(0xFF3B82F6),
                                    foregroundColor: Colors.white,
                                    icon: Icons.edit_rounded,
                                    label: 'Edit',
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                    ),
                                  ),
                                  SlidableAction(
                                    flex: 1,
                                    onPressed: (_) =>
                                        _confirmDelete(context, bank),
                                    backgroundColor: const Color(0xFFEF4444),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete_outline_rounded,
                                    label: 'Delete',
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                ],
                              ),
                              child: Card(
                                elevation: isDark ? 2 : 4,
                                margin: EdgeInsets.zero,
                                color: theme.cardColor,
                                shadowColor: typeColor.withValues(
                                  alpha: isDark ? 0.3 : 0.2,
                                ),
                                surfaceTintColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: CardWidget(color: typeColor, bank: bank),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  // ─── Quick Action Chip ─────────────────────────────────────────────
  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            8.wBox,
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
