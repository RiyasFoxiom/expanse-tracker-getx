import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/presentation/controllers/profile/profile_controller.dart';
import 'package:test_app/presentation/widgets/app_text.dart';
import 'package:test_app/core/extensions/space_ext.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const AppText("Profile", size: 22, weight: FontWeight.bold),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // Profile Avatar
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
                child: CircleAvatar(
                  radius: 56,
                  backgroundColor: Colors.transparent,
                  backgroundImage: const NetworkImage(
                    "https://img.icons8.com/?size=100&id=HEBTcR9O3uzR&format=png&color=000000",
                  ),
                ),
              ),
            ),
            24.hBox,

            // // User Name & Email
            // AppText(
            //   "John Doe",
            //   size: 26,
            //   weight: FontWeight.bold,
            //   color: textTheme.headlineMedium?.color,
            // ),
            // 8.hBox,
            // AppText(
            //   "john.doe@example.com",
            //   size: 16,
            //   color: colorScheme.onSurface.withValues(alpha: 0.7),
            // ),
            // 40.hBox,

            // Theme Option
            _profileOptionCard(
              context: context,
              icon: Icons.color_lens_outlined,
              title: "Theme",
              trailing: Obx(() {
                final mode = controller.themeMode.value;
                String label = mode == ThemeMode.light
                    ? "Light"
                    : mode == ThemeMode.dark
                    ? "Dark"
                    : "System";
                return AppText(
                  label,
                  size: 14,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                );
              }),
              onTap: () => _showThemeBottomSheet(context),
            ),

            80.hBox, // Extra space at bottom
          ],
        ),
      ),
    );
  }

  void _showThemeBottomSheet(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final theme = context.theme;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 40),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
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
            24.hBox,
            AppText(
              "Choose Theme",
              size: 20,
              weight: FontWeight.bold,
              color: theme.textTheme.titleLarge?.color,
            ),
            24.hBox,

            Obx(
              () => Column(
                children: [
                  _themeTile(
                    context: context,
                    title: "System Default",
                    icon: Icons.settings_outlined,
                    value: ThemeMode.system,
                    groupValue: controller.themeMode.value,
                    onChanged: (mode) {
                      controller.setTheme(mode);
                      Get.back();
                    },
                  ),
                  _themeTile(
                    context: context,
                    title: "Light Mode",
                    icon: Icons.light_mode,
                    value: ThemeMode.light,
                    groupValue: controller.themeMode.value,
                    onChanged: (mode) {
                      controller.setTheme(mode);
                      Get.back();
                    },
                  ),
                  _themeTile(
                    context: context,
                    title: "Dark Mode",
                    icon: Icons.dark_mode,
                    value: ThemeMode.dark,
                    groupValue: controller.themeMode.value,
                    onChanged: (mode) {
                      controller.setTheme(mode);
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _themeTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required ThemeMode value,
    required ThemeMode groupValue,
    required Function(ThemeMode) onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = value == groupValue;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? colorScheme.primary
            : colorScheme.onSurface.withValues(alpha: 0.7),
        size: 28,
      ),
      title: AppText(
        title,
        size: 17,
        weight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color: isSelected ? colorScheme.primary : null,
      ),
      trailing: RadioGroup<ThemeMode>(
        // value: value,
        groupValue: groupValue,
        // activeColor: colorScheme.primary,
        onChanged: (mode) => onChanged(mode!),
        child: Radio(value: value, activeColor: colorScheme.primary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () => onChanged(value),
    );
  }

  Widget _profileOptionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.primary, size: 30),
            20.wBox,
            Expanded(
              child: AppText(
                title,
                size: 17,
                weight: FontWeight.w600,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
