import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/data/models/bank_model.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key, required this.color, required this.bank});

  final Color color;
  final BankModel bank;

  // Mask card number: show only last 4 digits
  String _maskedCardNumber(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'\s+'), '');
    if (cleaned.length <= 4) return '•••• •••• •••• $cleaned';
    final last4 = cleaned.substring(cleaned.length - 4);
    return '•••• •••• •••• $last4';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: color,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          // ── Top Section ────────────────────────────────────────────────────
          Padding(
            padding: const .all(16),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Container(
                      padding: const .symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: .all(color: Colors.white, width: 1.5),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(2, 2)),
                        ],
                      ),
                      child: AppText(
                        bank.type.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: .w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    12.wBox,
                    Expanded(
                      child: AppText(
                        bank.name.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: .w900,
                          letterSpacing: 1,
                        ),
                        align: .right,
                        maxLines: 1,
                        overflow: .ellipsis,
                      ),
                    ),
                  ],
                ),
                20.hBox,
                AppText(
                  _maskedCardNumber(bank.cardNumber),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: .w900,
                    letterSpacing: 2,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),

          // ── Division Line ──────────────────────────────────────────────────
          Container(height: 2.5, color: Colors.black),

          // ── Bottom Section ─────────────────────────────────────────────────
          Padding(
            padding: const .fromLTRB(16, 12, 16, 16),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              crossAxisAlignment: .end,
              children: [
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    const AppText(
                      "BALANCE",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: .w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                    4.hBox,
                    AppText(
                      "₹${_formatBalance(bank.balance)}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: .w900,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  CupertinoIcons.checkmark_seal_fill,
                  color: Colors.black,
                  size: 28,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Format to comma-separated with 2 decimals
  String _formatBalance(double balance) {
    final parts = balance.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];

    final reversed = intPart.split('').reversed.toList();
    final buf = StringBuffer();
    for (int i = 0; i < reversed.length; i++) {
      if (i == 3 || (i > 3 && (i - 3) % 2 == 0)) buf.write(',');
      buf.write(reversed[i]);
    }
    return '${buf.toString().split('').reversed.join('')}.$decPart';
  }
}
