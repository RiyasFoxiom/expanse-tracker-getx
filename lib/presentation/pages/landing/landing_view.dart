import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/presentation/controllers/landing/landing_controller.dart';
import 'package:test_app/presentation/pages/banks/banks_view.dart';
import 'package:test_app/presentation/pages/category/categories_view.dart';
import 'package:test_app/presentation/pages/home/home_view.dart';
import 'package:test_app/presentation/pages/profile/profile_view.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

// ── Neo Brutalism tokens ────────────────────────────────────────────────────
const _kAccentYellow = Color(0xFFFFE600);
const _kNavBorder = BorderSide(color: Colors.black, width: 2.5);

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
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: KeyedSubtree(
              key: ValueKey(controller.currentIndex.value),
              child: pages[controller.currentIndex.value],
            ),
          ),
        ),
        bottomNavigationBar: const _NeoBrutalistBottomNav(),
      ),
    );
  }
}

class _NeoBrutalistBottomNav extends StatelessWidget {
  const _NeoBrutalistBottomNav();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LandingController>();

    final items = [
      {'icon': Icons.home_rounded, 'label': 'HOME'},
      {'icon': Icons.grid_view_rounded, 'label': 'CATS'},
      {'icon': Icons.account_balance_wallet_rounded, 'label': 'BANK'},
      {'icon': Icons.person_rounded, 'label': 'ME'},
    ];

    return Obx(() {
      final currentIndex = controller.currentIndex.value;
      // Read theme reactively using Theme.of(context) so it triggers rebuilds on theme change
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final bg = isDark ? const Color(0xFF1A1A1A) : Colors.white;

      return Container(
        margin: const .only(left: 12, right: 12, bottom: 14),
        decoration: BoxDecoration(
          color: bg,
          border: const .fromBorderSide(_kNavBorder),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(5, 5), blurRadius: 0),
          ],
        ),
        height: 68,
        child: Row(
          children: List.generate(items.length, (index) {
            final isSelected = currentIndex == index;
            final icon = items[index]['icon'] as IconData;
            final label = items[index]['label'] as String;

            return Expanded(
              child: GestureDetector(
                onTap: () => controller.setIndex(index),
                behavior: .opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    color: isSelected ? _kAccentYellow : Colors.transparent,
                    border: index < items.length - 1
                        ? const Border(
                            right: BorderSide(color: Colors.black, width: 2),
                          )
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: .center,
                    children: [
                      AnimatedScale(
                        scale: isSelected ? 1.15 : 1.0,
                        duration: const Duration(milliseconds: 180),
                        child: Icon(
                          icon,
                          size: 24,
                          color: isSelected
                              ? Colors.black
                              : (isDark ? Colors.white54 : Colors.black38),
                        ),
                      ),
                      3.hBox,
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 180),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: isSelected ? .w900 : .w700,
                          letterSpacing: 1,
                          color: isSelected
                              ? Colors.black
                              : (isDark ? Colors.white38 : Colors.black38),
                        ),
                        child: AppText(label),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
