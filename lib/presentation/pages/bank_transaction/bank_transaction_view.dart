import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/core/helpers/screen_helper.dart';
import 'package:test_app/presentation/controllers/bank_transaction/bank_transaction_controller.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

// ── Neo Brutalism tokens ─────────────────────────────────────────────────────
const _kAccentYellow = Color(0xFFFFE600);
const _kAccentGreen = Color(0xFF00C853);
const _kAccentRed = Color(0xFFFF1744);

class BankTransactionView extends GetView<BankTransactionController> {
  const BankTransactionView({super.key});

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
          padding: const .only(top: 8.0),
          child: Container(
            padding: const .symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _kAccentYellow,
              border: .all(color: Colors.black, width: 2.5),
            ),
            child: AppText(
              controller.bank.name.toUpperCase(),
              style: const TextStyle(
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

        if (controller.transactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: .center,
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
                    CupertinoIcons.building_2_fill,
                    size: 50,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
                24.hBox,
                AppText(
                  "NO TRANSACTIONS YET",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: .w900,
                    color: isDark ? Colors.white54 : Colors.black54,
                    letterSpacing: 1,
                  ),
                ),
                8.hBox,
                AppText(
                  "MATCHED TRANSACTIONS WILL APPEAR HERE",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: .w700,
                    color: isDark ? Colors.white38 : Colors.black38,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          );
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
                    _nbLabel("TRANSACTION HISTORY", isDark),
                    18.hBox,
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.transactions.length,
                      separatorBuilder: (_, index) => 16.hBox,
                      itemBuilder: (context, index) {
                        final tx = controller.transactions[index];
                        final isIncome = tx.type == 'income';
                        final accentColor = isIncome
                            ? _kAccentGreen
                            : _kAccentRed;

                        return Container(
                          decoration: BoxDecoration(
                            color: cardBg,
                            border: .all(color: Colors.black, width: 2.5),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(4, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const .all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: accentColor,
                                    border: .all(color: Colors.black, width: 2),
                                  ),
                                  child: Icon(
                                    isIncome
                                        ? CupertinoIcons.arrow_down_left
                                        : CupertinoIcons.arrow_up_right,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                16.wBox,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: .start,
                                    children: [
                                      AppText(
                                        tx.category.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: .w900,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      4.hBox,
                                      AppText(
                                        DateFormat(
                                          'MMM dd, yyyy',
                                        ).format(tx.date).toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: .w700,
                                          color: isDark
                                              ? Colors.white54
                                              : Colors.black54,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: .end,
                                  children: [
                                    AppText(
                                      "${isIncome ? '+' : '-'}₹${tx.amount.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: .w900,
                                        color: accentColor,
                                      ),
                                    ),
                                    if (tx.notes != null &&
                                        tx.notes!.isNotEmpty) ...[
                                      2.hBox,
                                      const Icon(
                                        CupertinoIcons.text_bubble_fill,
                                        size: 12,
                                        color: Colors.black26,
                                      ),
                                    ],
                                  ],
                                ),
                              ],
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
}
