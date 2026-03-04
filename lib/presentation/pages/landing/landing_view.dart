import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      builder: (controller) => Scaffold(
        extendBody: true,
        body: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: KeyedSubtree(
              key: ValueKey(controller.currentIndex.value),
              child: pages[controller.currentIndex.value],
            ),
          ),
        ),
        bottomNavigationBar: const _DynamicBottomNav(),
      ),
    );
  }
}

class _DynamicBottomNav extends StatelessWidget {
  const _DynamicBottomNav();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LandingController>();
    final theme = context.theme;
    final isDark = Get.isDarkMode;

    final items = [
      {'icon': Icons.home_rounded},
      {'icon': Icons.grid_view_rounded},
      {'icon': Icons.account_balance_wallet_rounded},
      {'icon': Icons.person_rounded},
    ];

    return Obx(() {
      final currentIndex = controller.currentIndex.value;

      return Container(
        margin: const .only(left: 16, right: 16, bottom: 16),
        height: 72,
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1E293B).withValues(alpha: 0.8)
              : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : theme.colorScheme.primary.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
          border: .all(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white,
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: .circular(36),
          child: BackdropFilter(
            filter: .blur(sigmaX: 12, sigmaY: 12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final tabWidth = constraints.maxWidth / items.length;
                const bubbleSize = 52.0;
                final bubbleStartOffset = (tabWidth - bubbleSize) / 2;

                return Stack(
                  children: [
                    // ── Animated sliding bubble
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves
                          .easeOutBack, // Gives that satisfying bounce effect
                      top: 10, // Center vertically (72 - 52) / 2 = 10
                      left: tabWidth * currentIndex + bubbleStartOffset,
                      child: Container(
                        width: bubbleSize,
                        height: bubbleSize,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: .circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.4,
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // ── Icons
                    Row(
                      children: List.generate(items.length, (index) {
                        final isSelected = currentIndex == index;
                        final icon = items[index]['icon'] as IconData;

                        return SizedBox(
                          width: tabWidth,
                          child: GestureDetector(
                            onTap: () => controller.setIndex(index),
                            behavior: .opaque,
                            child: AnimatedTheme(
                              data: theme.copyWith(
                                iconTheme: IconThemeData(
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark
                                            ? Colors.white54
                                            : Colors.black45),
                                  size: isSelected ? 26 : 24,
                                ),
                              ),
                              child: Center(child: Icon(icon)),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    });
  }
}
