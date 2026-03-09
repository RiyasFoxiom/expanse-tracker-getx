import 'package:flutter/cupertino.dart';
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
import 'package:test_app/presentation/widgets/app_dialogs.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

// ── Neo Brutalism tokens ─────────────────────────────────────────────────────
const _kBorder = BorderSide(color: Colors.black, width: 2.5);
const _kAccentYellow = Color(0xFFFFE600);
const _kAccentGreen = Color(0xFF00C853);
const _kAccentRed = Color(0xFFFF1744);
const _kAccentBlue = Color(0xFF2979FF);
const _kAccentPurple = Color(0xFF7C4DFF);

class BanksView extends GetView<BanksController> {
  const BanksView({super.key});

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'savings':
        return _kAccentGreen;
      case 'credit':
        return _kAccentBlue;
      case 'debit':
        return _kAccentYellow;
      case 'salary':
        return _kAccentPurple;
      default:
        return _kAccentPurple;
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
      AppDialogs.showSnackbar(
        message: 'You need at least 2 banks to make a transfer',
        title: 'Not Enough Banks',
        isError: true,
      );
      return;
    }

    final amountCtrl = TextEditingController();
    final Rx<BankModel?> fromBank = Rx(null);
    final Rx<BankModel?> toBank = Rx(null);
    final isDark = Theme.of(context).brightness == .dark;
    final sheetBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;

    Get.bottomSheet(
      Container(
        padding: const .symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: sheetBg,
          border: const Border(top: _kBorder, left: _kBorder, right: _kBorder),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(0, -6)),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              // Header
              Container(
                padding: const .symmetric(horizontal: 10, vertical: 4),
                color: _kAccentPurple,
                child: const AppText(
                  "TRANSFER FUNDS",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: .w900,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              24.hBox,

              // From
              _nbLabel("FROM ACCOUNT", isDark),
              10.hBox,
              SizedBox(
                height: 90,
                child: Obx(
                  () => _buildBankSelector(fromBank, toBank.value, isDark),
                ),
              ),
              20.hBox,

              // Arrow
              Center(
                child: Container(
                  padding: const .all(8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white : Colors.black,
                    border: .all(
                      color: isDark ? Colors.white : Colors.black,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    CupertinoIcons.arrow_down,
                    color: isDark ? Colors.black : Colors.white,
                    size: 20,
                  ),
                ),
              ),
              20.hBox,

              // To
              _nbLabel("TO ACCOUNT", isDark),
              10.hBox,
              SizedBox(
                height: 90,
                child: Obx(
                  () => _buildBankSelector(toBank, fromBank.value, isDark),
                ),
              ),
              24.hBox,

              // Amount
              _nbLabel("AMOUNT", isDark),
              10.hBox,
              Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.black : Colors.white,
                  border: .all(color: Colors.black, width: 2.5),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                  ],
                ),
                child: TextField(
                  controller: amountCtrl,
                  keyboardType: const .numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  style: TextStyle(
                    fontWeight: .w900,
                    fontSize: 22,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    prefixText: '₹ ',
                    prefixStyle: const TextStyle(
                      fontWeight: .w900,
                      color: _kAccentPurple,
                    ),
                    border: .none,
                    contentPadding: const .all(16),
                  ),
                ),
              ),
              32.hBox,

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: _nbButton(
                      label: "CANCEL",
                      color: isDark ? Colors.white10 : Colors.black12,
                      textColor: Colors.white,
                      onTap: () => Get.back(),
                    ),
                  ),
                  16.wBox,
                  Expanded(
                    child: _nbButton(
                      label: "TRANSFER",
                      color: _kAccentBlue,
                      textColor: Colors.white,
                      onTap: () {
                        if (fromBank.value == null || toBank.value == null) {
                          AppDialogs.showSnackbar(
                            message:
                                'Please select both source and destination banks',
                            title: 'Select Banks',
                            isError: true,
                          );
                          return;
                        }
                        final amount = double.tryParse(amountCtrl.text) ?? 0;
                        if (amount <= 0) {
                          AppDialogs.showSnackbar(
                            message: 'Enter a valid transfer amount',
                            title: 'Invalid Amount',
                            isError: true,
                          );
                          return;
                        }
                        controller.transferFunds(
                          fromBank.value!.id!,
                          toBank.value!.id!,
                          amount,
                        );
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
              MediaQuery.of(context).viewInsets.bottom.hBox,
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildBankSelector(
    Rx<BankModel?> selected,
    BankModel? excluded,
    bool isDark,
  ) {
    final available = controller.banks
        .where((b) => b.id != excluded?.id)
        .toList();
    return ListView.separated(
      scrollDirection: .horizontal,
      itemCount: available.length,
      separatorBuilder: (_, index) => 12.wBox,
      itemBuilder: (_, i) {
        final bank = available[i];
        final isSelected = selected.value?.id == bank.id;
        final typeColor = _getTypeColor(bank.type);
        return GestureDetector(
          onTap: () => selected.value = bank,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 160,
            padding: const .all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? typeColor
                  : (isDark ? const Color(0xFF2A2A2A) : Colors.white),
              border: .all(color: Colors.black, width: 2.5),
              boxShadow: isSelected
                  ? const [BoxShadow(color: Colors.black, offset: Offset(3, 3))]
                  : [],
            ),
            child: Column(
              crossAxisAlignment: .start,
              mainAxisAlignment: .center,
              children: [
                AppText(
                  bank.name.toUpperCase(),
                  style: TextStyle(
                    fontWeight: .w900,
                    fontSize: 12,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white70 : Colors.black87),
                  ),
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
                4.hBox,
                AppText(
                  "₹${bank.balance.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontWeight: .w900,
                    fontSize: 16,
                    color: isSelected ? Colors.white : typeColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── Delete confirmation ────────────────────────────────────────────
  Future<void> _confirmDelete(BuildContext context, BankModel bank) async {
    final hasTx = await controller.repo.hasTransactions(bank.id!);
    final confirmed = await AppDialogs.showConfirmDialog(
      title: "DELETE BANK?",
      content: hasTx
          ? "THIS BANK HAS TRANSACTIONS. DELETE ANYWAY? THIS CANNOT BE UNDONE."
          : "THIS BANK WILL BE PERMANENTLY DELETED.",
      isDestructive: true,
    );

    if (confirmed == true) {
      await controller.deleteBank(bank.id!);
    }
  }

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
        title: Padding(
          padding: const .only(top: 8.0),
          child: Container(
            padding: const .symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _kAccentYellow,
              border: .all(color: Colors.black, width: 2.5),
            ),
            child: const AppText(
              'MY BANKS',
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
      floatingActionButton: Padding(
        padding: const .only(bottom: 80),
        child: GestureDetector(
          onTap: () {
            if (Get.isRegistered<AddBanksController>()) {
              Get.find<AddBanksController>().resetForAdd();
            }
            Screen.open(const AddBanksView(), binding: AddBanksBinding());
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: _kAccentBlue,
              border: .all(color: Colors.black, width: 2.5),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(4, 4)),
              ],
            ),
            child: const Icon(
              CupertinoIcons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CupertinoActivityIndicator(radius: 16));
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const .all(16.0),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    // Total Balance Card
                    Container(
                      width: double.infinity,
                      padding: const .all(16),
                      decoration: BoxDecoration(
                        color: _kAccentPurple,
                        border: .all(color: Colors.black, width: 2.5),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(6, 6)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          const AppText(
                            "TOTAL BALANCE",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: .w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          8.hBox,
                          AppText(
                            "₹${_getTotalBalance().toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: .w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          12.hBox,
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            color: Colors.black,
                            child: AppText(
                              "${controller.banks.length} ACCOUNTS",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: .w900,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    18.hBox,

                    // Quick Actions
                    Row(
                      children: [
                        Expanded(
                          child: _nbButton(
                            label: "TRANSFER",
                            icon: CupertinoIcons.arrow_right_arrow_left,
                            color: _kAccentYellow,
                            textColor: Colors.black,
                            onTap: () => _showTransferSheet(context),
                          ),
                        ),
                        16.wBox,
                        Expanded(
                          child: _nbButton(
                            label: "ADD BANK",
                            icon: CupertinoIcons.plus_square,
                            color: _kAccentGreen,
                            textColor: Colors.white,
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
                        ),
                      ],
                    ),
                    18.hBox,

                    _nbLabel("YOUR ACCOUNTS", isDark),
                    18.hBox,

                    if (controller.banks.isEmpty)
                      _buildEmptyState(isDark, cardBg)
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.banks.length,
                        separatorBuilder: (_, index) => 16.hBox,
                        itemBuilder: (context, index) {
                          final bank = controller.banks[index];
                          final typeColor = _getTypeColor(bank.type);
                          return Slidable(
                            key: ValueKey(bank.id),
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              extentRatio: 0.5,
                              children: [
                                CustomSlidableAction(
                                  onPressed: (_) {
                                    Screen.open(
                                      const AddBanksView(),
                                      binding: AddBanksBinding(),
                                    );
                                    if (Get.isRegistered<
                                      AddBanksController
                                    >()) {
                                      Get.find<AddBanksController>()
                                          .setupForEdit(bank);
                                    }
                                  },
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      color: _kAccentBlue,
                                      border: const Border(
                                        top: _kBorder,
                                        bottom: _kBorder,
                                        left: _kBorder,
                                      ),
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.pencil,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                CustomSlidableAction(
                                  onPressed: (_) =>
                                      _confirmDelete(context, bank),
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      color: _kAccentRed,
                                      border: .all(
                                        color: Colors.black,
                                        width: 2.5,
                                      ),
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.trash,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () => Screen.open(
                                BankTransactionView(),
                                binding: BankTransactionBinding(bank),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: cardBg,
                                  border: .all(color: Colors.black, width: 2.5),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black,
                                      offset: Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: CardWidget(color: typeColor, bank: bank),
                              ),
                            ),
                          );
                        },
                      ),
                    100.hBox,
                  ],
                ),
              ),
            ),
          ],
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

  Widget _nbButton({
    required String label,
    required Color color,
    required Color textColor,
    IconData? icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const .symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          border: .all(color: Colors.black, width: 2.5),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(4, 4)),
          ],
        ),
        alignment: .center,
        child: Row(
          mainAxisAlignment: .center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor, size: 18),
              8.wBox,
            ],
            AppText(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: .w900,
                color: textColor,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, Color cardBg) {
    return Center(
      child: Padding(
        padding: const .symmetric(vertical: 40),
        child: Column(
          children: [
            Container(
              padding: const .all(24),
              decoration: BoxDecoration(
                color: cardBg,
                border: .all(color: Colors.black, width: 2.5),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(6, 6)),
                ],
              ),
              child: Icon(
                CupertinoIcons.briefcase,
                size: 50,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
            24.hBox,
            AppText(
              "NO BANKS OR CARDS YET",
              style: TextStyle(
                fontSize: 16,
                fontWeight: .w900,
                color: isDark ? Colors.white54 : Colors.black54,
                letterSpacing: 1,
              ),
            ),
            8.hBox,
            AppText(
              "TAP '+' TO GET STARTED",
              style: TextStyle(
                fontSize: 13,
                fontWeight: .w700,
                color: isDark ? Colors.white38 : Colors.black38,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
