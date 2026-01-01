import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/data/models/bank_model.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key, required this.color, required this.bank});

  final Color color;
  final BankModel bank;

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    // Adjust text/opacity for better readability in dark mode
    final Color textColor = Colors.white;
    final Color subtleTextColor = Colors.white.withValues(
      alpha: isDark ? 0.8 : 0.6,
    );
    final Color overlayColor = Colors.white.withValues(
      alpha: isDark ? 0.25 : 0.17,
    );

    return Stack(
      children: [
        Container(
          height: 220,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color,
                color.withValues(alpha: isDark ? 0.9 : 0.85),
                color.withValues(alpha: isDark ? 0.8 : 0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha:0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha:0.3),
                          width: 1,
                        ),
                      ),
                      child: AppText(
                        bank.type.capitalize!,
                        color: textColor,
                        size: 13,
                        weight: FontWeight.w600,
                      ),
                    ),
                    Icon(Icons.contactless, color: textColor, size: 32),
                  ],
                ),

                const Spacer(),

                // Card details
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      bank.cardNumber,
                      color: textColor,
                      size: 21,
                      weight: FontWeight.w500,
                      letterSpacing: 3,
                    ),
                    16.hBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              "BALANCE",
                              color: subtleTextColor,
                              size: 11,
                              weight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                            4.hBox,
                            AppText(
                              "₹${bank.balance.toStringAsFixed(0)}",
                              color: textColor,
                              size: 26,
                              weight: FontWeight.bold,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            AppText(
                              "BANK",
                              color: subtleTextColor,
                              size: 11,
                              weight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                            4.hBox,
                            AppText(
                              bank.name,
                              color: textColor,
                              size: 17,
                              weight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Decorative circles
        Positioned(
          top: -60,
          right: -45,
          child: CircleContainer(overlayColor: overlayColor),
        ),
        Positioned(
          top: -60,
          right: 45,
          child: CircleContainer(overlayColor: overlayColor),
        ),
      ],
    );
  }
}

class CircleContainer extends StatelessWidget {
  const CircleContainer({super.key, required this.overlayColor});

  final Color overlayColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(color: overlayColor, shape: BoxShape.circle),
    );
  }
}
