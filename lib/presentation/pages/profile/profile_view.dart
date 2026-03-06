import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/core/helpers/screen_helper.dart';
import 'package:test_app/presentation/controllers/profile/profile_controller.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

// ── Neo Brutalism tokens ─────────────────────────────────────────────────────
const _kBorder = BorderSide(color: Colors.black, width: 2.5);
const _kAccentYellow = Color(0xFFFFE600);
const _kAccentBlue = Color(0xFF2979FF);
const _kAccentGreen = Color(0xFF00C853);
const _kAccentOrange = Color(0xFFFF6D00);
const _kAccentPurple = Color(0xFF7C4DFF);

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

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
              'SETTINGS',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 18,
                fontWeight: .w900,
                color: Colors.black,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const .symmetric(horizontal: 16, vertical: 20),
        children: [
          // ── Profile Banner ─────────────────────────────────────────
          Container(
            padding: const .all(16),
            decoration: BoxDecoration(
              color: cardBg,
              border: const .fromBorderSide(_kBorder),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(6, 6),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: [
                // Avatar block
                Container(
                  width: 72,
                  height: 72,
                  color: _kAccentYellow,
                  child: const Icon(
                    CupertinoIcons.person_solid,
                    size: 38,
                    color: Colors.black,
                  ),
                ),
                18.wBox,
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Container(
                      padding: const .symmetric(horizontal: 8, vertical: 3),
                      color: Colors.black,
                      child: const AppText(
                        'YOUR PROFILE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: .w900,
                          letterSpacing: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    8.hBox,
                    AppText(
                      'budget@tracker.app',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: .w700,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          32.hBox,

          // ── PREFERENCES section label ──────────────────────────────
          _sectionLabel('PREFERENCES', isDark),
          10.hBox,

          // Theme Mode row
          _buildSettingsRow(
            isDark: isDark,
            cardBg: cardBg,
            accentColor: _kAccentPurple,
            icon: CupertinoIcons.moon_stars_fill,
            title: 'THEME MODE',
            trailing: Obx(() {
              final mode = controller.themeMode.value;
              final label = mode == ThemeMode.light
                  ? 'LIGHT'
                  : mode == ThemeMode.dark
                  ? 'DARK'
                  : 'SYSTEM';
              return Row(
                children: [
                  Container(
                    padding: const .symmetric(horizontal: 8, vertical: 3),
                    color: _kAccentPurple,
                    child: AppText(
                      label,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: .w900,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  8.wBox,
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ],
              );
            }),
            onTap: () => _showThemeBottomSheet(context),
            showBottomBorder: false,
          ),

          32.hBox,

          // ── ABOUT section label ────────────────────────────────────
          _sectionLabel('ABOUT', isDark),
          10.hBox,

          // Rate App
          _buildSettingsRow(
            isDark: isDark,
            cardBg: cardBg,
            accentColor: _kAccentOrange,
            icon: CupertinoIcons.star_fill,
            title: 'RATE APP',
            onTap: () {},
            showBottomBorder: true,
          ),
          // Privacy Policy
          _buildSettingsRow(
            isDark: isDark,
            cardBg: cardBg,
            accentColor: _kAccentGreen,
            icon: CupertinoIcons.shield_fill,
            title: 'PRIVACY POLICY',
            onTap: () {},
            showBottomBorder: true,
          ),
          // App Version
          _buildSettingsRow(
            isDark: isDark,
            cardBg: cardBg,
            accentColor: _kAccentBlue,
            icon: CupertinoIcons.info_circle_fill,
            title: 'APP VERSION',
            trailing: Obx(
              () => Container(
                padding: const .symmetric(horizontal: 8, vertical: 3),
                color: _kAccentBlue,
                child: AppText(
                  controller.appVersion.value.isEmpty
                      ? '...'
                      : controller.appVersion.value.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: .w900,
                    letterSpacing: 1,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            onTap: () {},
            showBottomBorder: false,
          ),

          100.hBox,
        ],
      ),
    );
  }

  // ── Section Label ──────────────────────────────────────────────────────────
  Widget _sectionLabel(String text, bool isDark) {
    return Row(
      children: [
        Container(width: 4, height: 20, color: _kAccentYellow),
        8.wBox,
        AppText(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: .w900,
            letterSpacing: 2,
            color: isDark ? Colors.white60 : Colors.black45,
          ),
        ),
      ],
    );
  }

  // ── Settings Row ───────────────────────────────────────────────────────────
  Widget _buildSettingsRow({
    required bool isDark,
    required Color cardBg,
    required Color accentColor,
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
    required bool showBottomBorder,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const .symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: cardBg,
          border: Border(
            left: const BorderSide(color: Colors.black, width: 2.5),
            right: const BorderSide(color: Colors.black, width: 2.5),
            top: const BorderSide(color: Colors.black, width: 2.5),
            bottom: showBottomBorder
                ? const BorderSide(color: Colors.black, width: 1)
                : const BorderSide(color: Colors.black, width: 2.5),
          ),
          boxShadow: showBottomBorder
              ? null
              : const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
        ),
        child: Row(
          children: [
            // Icon block
            Container(
              width: 40,
              height: 40,
              color: accentColor,
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            16.wBox,
            Expanded(
              child: AppText(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: .w900,
                  letterSpacing: 0.5,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            if (trailing != null)
              trailing
            else
              Icon(
                Icons.arrow_forward,
                size: 18,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
          ],
        ),
      ),
    );
  }

  // ── Theme Bottom Sheet ─────────────────────────────────────────────────────
  void _showThemeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        final sheetIsDark =
            Theme.of(sheetContext).brightness == Brightness.dark;
        final sheetBg = sheetIsDark
            ? const Color(0xFF0F0F0F)
            : const Color(0xFFF5F5F0);
        final sheetCardBg = sheetIsDark
            ? const Color(0xFF1A1A1A)
            : Colors.white;
        return Container(
          padding: const .fromLTRB(16, 16, 16, 40),
          decoration: BoxDecoration(
            color: sheetBg,
            border: const Border(
              top: BorderSide(color: Colors.black, width: 2.5),
              left: BorderSide(color: Colors.black, width: 2.5),
              right: BorderSide(color: Colors.black, width: 2.5),
            ),
          ),
          child: Column(
            mainAxisSize: .min,
            children: [
              // Grabber
              Container(width: 40, height: 4, color: Colors.black26),
              20.hBox,
              // Sheet Title
              Container(
                padding: const .symmetric(horizontal: 12, vertical: 6),
                color: _kAccentYellow,
                child: AppText(
                  'SELECT THEME',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: .w900,
                    letterSpacing: 2,
                    color: Colors.black,
                  ),
                ),
              ),
              20.hBox,
              _buildThemeOption(
                sheetContext,
                cardBg: sheetCardBg,
                isDark: sheetIsDark,
                mode: .system,
                label: 'SYSTEM DEFAULT',
                icon: CupertinoIcons.device_phone_portrait,
                accentColor: _kAccentBlue,
              ),
              10.hBox,
              _buildThemeOption(
                sheetContext,
                cardBg: sheetCardBg,
                isDark: sheetIsDark,
                mode: .light,
                label: 'LIGHT MODE',
                icon: CupertinoIcons.sun_max_fill,
                accentColor: _kAccentOrange,
              ),
              10.hBox,
              _buildThemeOption(
                sheetContext,
                cardBg: sheetCardBg,
                isDark: sheetIsDark,
                mode: .dark,
                label: 'DARK MODE',
                icon: CupertinoIcons.moon_fill,
                accentColor: _kAccentPurple,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required Color cardBg,
    required bool isDark,
    required ThemeMode mode,
    required String label,
    required IconData icon,
    required Color accentColor,
  }) {
    return Obx(() {
      final isSelected = controller.themeMode.value == mode;
      return GestureDetector(
        onTap: () {
          controller.setTheme(mode);
          Screen.close();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const .symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? accentColor : cardBg,
            border: .all(color: Colors.black, width: 2.5),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(3, 3),
                      blurRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white70 : Colors.black87),
              ),
              16.wBox,
              Expanded(
                child: AppText(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: .w900,
                    letterSpacing: 0.8,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white : Colors.black),
                  ),
                ),
              ),
              if (isSelected)
                Container(
                  padding: const .all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: .circle,
                  ),
                  child: Icon(Icons.check, size: 14, color: accentColor),
                ),
            ],
          ),
        ),
      );
    });
  }
}
