import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/presentation/controllers/splash/splash_controller.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

// ── Neo Brutalism tokens ────────────────────────────────────────────────────
const _kAccentYellow = Color(0xFFFFE600);
const _kBorder = BorderSide(color: Colors.black, width: 3.0);

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == .dark;
    final bg = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F5F0);

    return Scaffold(
      backgroundColor: bg,
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            // Brutalist App Icon
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: _kAccentYellow,
                border: .fromBorderSide(_kBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(8, 8),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 60,
                  color: Colors.black,
                ),
              ),
            ),
            40.hBox,

            // Title Badge
            Container(
              padding: const .symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.white : Colors.black,
                border: .all(
                  color: isDark ? Colors.white : Colors.black,
                  width: 2,
                ),
              ),
              child: AppText(
                "BUDGET TRACKER",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: .w900,
                  letterSpacing: 2,
                  color: isDark ? Colors.black : Colors.white,
                ),
              ),
            ),
            16.hBox,

            // Tagline
            AppText(
              "TRACK INTELLIGENTLY.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: .w900,
                letterSpacing: 1.5,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
