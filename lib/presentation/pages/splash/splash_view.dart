import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/presentation/controllers/splash/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = Get.isDarkMode;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon with soft shadow (Apple-like App Icon style)
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [const Color(0xFF6C3FEE), const Color(0xFF4B23B5)]
                      : [const Color(0xFF8B64FF), const Color(0xFF6C3FEE)],
                ),
                borderRadius: BorderRadius.circular(
                  28,
                ), // Apple's continuous curve approximation
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xFF6C3FEE,
                    ).withValues(alpha: isDark ? 0.4 : 0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 56,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Title
            Text(
              "Budget Tracker",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            // Tagline
            Text(
              "Track intelligently.",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                letterSpacing: 0.2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
