import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/presentation/controllers/splash/splash_controller.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: Get.isDarkMode
                ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                : [const Color(0xFF4A90E2), const Color(0xFF007AFF)],
          ),
        ),
        child: Column(
          children: [
            const Spacer(flex: 3),

            /// App Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: Get.isDarkMode ? 0.1 : 0.15,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                size: 60,
                color: Colors.white,
              ),
            ),

            20.hBox,

            /// App Name
            const AppText(
              "Budget Tracker",
              size: 28,
              weight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),

            8.hBox,

            /// Tagline
            const AppText(
              "Track your expenses smartly",
              size: 14,
              color: Colors.white70,
            ),

            const Spacer(flex: 4),

            /// Version
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: AppText("Version 1.0.0", size: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
