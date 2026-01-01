import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:test_app/presentation/controllers/landing/landing_controller.dart';
import 'package:test_app/presentation/pages/banks/banks_view.dart';
import 'package:test_app/presentation/pages/category/categories_view.dart';
import 'package:test_app/presentation/pages/home/home_view.dart';
import 'package:test_app/presentation/pages/profile/profile_view.dart';

class LandingView extends StatelessWidget {
  final int pageIndex;
  const LandingView({super.key, this.pageIndex = 0});

  static final List<Widget> pages = [
    HomeView(),
    const CategoriesView(),
    BanksView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LandingController>(
      initState: (state) {
        state.controller?.setIndex(pageIndex);
      },
      builder: (controller) => Obx(
        () => Scaffold(
          body: pages[controller.currentIndex.value],
          bottomNavigationBar: _buildGNav(context, controller),
        ),
      ),
    );
  }

  Widget _buildGNav(BuildContext context, LandingController controller) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final isDark = Get.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: GNav(
            selectedIndex: controller.currentIndex.value,
            onTabChange: controller.setIndex,
            gap: 8,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            tabBorderRadius: 16,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 400),
            color: colorScheme.onSurface.withValues(alpha: 0.6),
            activeColor: colorScheme.primary,
            tabBackgroundColor: colorScheme.primary.withValues(alpha: .1),
            rippleColor: colorScheme.primary.withValues(alpha: 0.15),
            hoverColor: colorScheme.primary.withValues(alpha: 0.08),
            tabBorder: Border.all(
              color: isDark ? Colors.white10 : Colors.black12,
              width: 1,
            ),
            tabs: const [
              GButton(icon: Icons.home_outlined, text: 'Home'),
              GButton(icon: Icons.category_outlined, text: 'Categories'),
              GButton(icon: Icons.credit_card_outlined, text: 'Banks'),
              GButton(icon: Icons.person_outline, text: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}
