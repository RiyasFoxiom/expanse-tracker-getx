import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/presentation/controllers/profile/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = Get.isDarkMode;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 70,
        title: Text(
          "Settings",
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          // Profile Banner
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.04),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    CupertinoIcons.person_solid,
                    size: 40,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Profile",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "budget@tracker.app",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),

          Text(
            "PREFERENCES",
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 12),

          // Settings Group
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSettingsRow(
                  context,
                  icon: CupertinoIcons.moon_stars_fill,
                  iconColor: const Color(0xFF5E5CE6),
                  title: "Theme Mode",
                  trailing: Obx(() {
                    final mode = controller.themeMode.value;
                    final label = mode == ThemeMode.light
                        ? "Light"
                        : mode == ThemeMode.dark
                        ? "Dark"
                        : "System";
                    return Row(
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          CupertinoIcons.chevron_forward,
                          size: 18,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ],
                    );
                  }),
                  onTap: () => _showThemeBottomSheet(context),
                  showDivider: false,
                ),
              ],
            ),
          ),

          const SizedBox(height: 48),

          Text(
            "ABOUT",
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 12),

          // About Group
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSettingsRow(
                  context,
                  icon: CupertinoIcons.star_fill,
                  iconColor: const Color(0xFFFF9500),
                  title: "Rate App",
                  onTap: () {},
                  showDivider: true,
                ),
                _buildSettingsRow(
                  context,
                  icon: CupertinoIcons.shield_fill,
                  iconColor: const Color(0xFF34C759),
                  title: "Privacy Policy",
                  onTap: () {},
                  showDivider: true,
                ),
                _buildSettingsRow(
                  context,
                  icon: CupertinoIcons.info_circle_fill,
                  iconColor: const Color(0xFF007AFF),
                  title: "App Version",
                  trailing: Obx(
                    () => Text(
                      controller.appVersion.value.isEmpty
                          ? '...'
                          : controller.appVersion.value,
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {},
                  showDivider: false,
                ),
              ],
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSettingsRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
    required bool showDivider,
  }) {
    final theme = context.theme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (trailing != null) trailing,
                if (trailing == null)
                  Icon(
                    CupertinoIcons.chevron_forward,
                    size: 18,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
              ],
            ),
            if (showDivider)
              Container(
                margin: const EdgeInsets.only(top: 16, left: 52),
                height: 0.5,
                color: theme.dividerColor,
              ),
          ],
        ),
      ),
    );
  }

  void _showThemeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = context.theme;
        final isDark = Get.isDarkMode;
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Select Theme",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              _buildThemeOption(
                context,
                ThemeMode.system,
                "System Default",
                CupertinoIcons.device_phone_portrait,
              ),
              const SizedBox(height: 12),
              _buildThemeOption(
                context,
                ThemeMode.light,
                "Light Mode",
                CupertinoIcons.sun_max_fill,
              ),
              const SizedBox(height: 12),
              _buildThemeOption(
                context,
                ThemeMode.dark,
                "Dark Mode",
                CupertinoIcons.moon_fill,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeMode mode,
    String title,
    IconData icon,
  ) {
    final isDark = Get.isDarkMode;
    return Obx(() {
      final isSelected = controller.themeMode.value == mode;
      final theme = context.theme;
      return GestureDetector(
        onTap: () {
          controller.setTheme(mode);
          Navigator.pop(context);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : (isDark ? const Color(0xFF283040) : const Color(0xFFF0F1F5)),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? theme.colorScheme.primary
                    : (isDark ? Colors.white70 : Colors.black87),
                size: 22,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : (isDark ? Colors.white : Colors.black),
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  CupertinoIcons.check_mark_circled_solid,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
            ],
          ),
        ),
      );
    });
  }
}
