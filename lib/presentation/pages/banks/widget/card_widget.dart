import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/data/models/bank_model.dart';

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

  IconData _typeIcon() {
    switch (bank.type.toLowerCase()) {
      case 'savings':
        return Icons.savings_rounded;
      case 'credit':
        return Icons.credit_card_rounded;
      case 'debit':
        return Icons.account_balance_wallet_rounded;
      default:
        return Icons.account_balance_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    // Generate a secondary color for gradient
    final HSLColor hsl = HSLColor.fromColor(color);
    final Color gradEnd = hsl
        .withHue((hsl.hue + 30) % 360)
        .withLightness((hsl.lightness * 0.7).clamp(0.0, 1.0))
        .toColor();

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          // ── Background gradient
          Container(
            height: 210,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, gradEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // ── Glassmorphism pattern overlay
          Positioned(
            top: -80,
            right: -50,
            child: _GlassCircle(size: 200, opacity: isDark ? 0.08 : 0.1),
          ),
          Positioned(
            top: -30,
            right: 30,
            child: _GlassCircle(size: 140, opacity: isDark ? 0.06 : 0.08),
          ),
          Positioned(
            bottom: -60,
            left: -40,
            child: _GlassCircle(size: 160, opacity: isDark ? 0.05 : 0.07),
          ),

          // ── Subtle mesh lines
          Positioned.fill(
            child: CustomPaint(
              painter: _CardPatternPainter(
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),

          // ── Content
          SizedBox(
            height: 210,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: badge + NFC icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_typeIcon(), color: Colors.white, size: 14),
                            6.wBox,
                            Text(
                              bank.type.capitalize!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // NFC chip
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.contactless_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Card number – masked
                  Text(
                    _maskedCardNumber(bank.cardNumber),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2.5,
                      fontFamily: 'monospace',
                    ),
                  ),

                  14.hBox,

                  // Bottom row: balance + bank name
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Balance column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "BALANCE",
                              style: TextStyle(
                                color: Colors.white.withValues(
                                  alpha: isDark ? 0.65 : 0.55,
                                ),
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.8,
                              ),
                            ),
                            4.hBox,
                            Text(
                              "₹${_formatBalance(bank.balance)}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Bank name column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "BANK",
                            style: TextStyle(
                              color: Colors.white.withValues(
                                alpha: isDark ? 0.65 : 0.55,
                              ),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.8,
                            ),
                          ),
                          4.hBox,
                          Container(
                            constraints: const BoxConstraints(maxWidth: 130),
                            child: Text(
                              bank.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
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

    // Indian style grouping — last 3, then every 2
    final reversed = intPart.split('').reversed.toList();
    final buf = StringBuffer();
    for (int i = 0; i < reversed.length; i++) {
      if (i == 3 || (i > 3 && (i - 3) % 2 == 0)) buf.write(',');
      buf.write(reversed[i]);
    }
    return '${buf.toString().split('').reversed.join('')}.$decPart';
  }
}

// ─── Glass circle decoration ─────────────────────────────────────────
class _GlassCircle extends StatelessWidget {
  const _GlassCircle({required this.size, required this.opacity});
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}

// ─── Subtle diagonal line pattern painter ────────────────────────────
class _CardPatternPainter extends CustomPainter {
  _CardPatternPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;

    const spacing = 24.0;
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
