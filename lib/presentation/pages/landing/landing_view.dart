import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/presentation/controllers/landing/landing_controller.dart';
import 'package:test_app/presentation/pages/banks/banks_view.dart';
import 'package:test_app/presentation/pages/category/categories_view.dart';
import 'package:test_app/presentation/pages/home/home_view.dart';
import 'package:test_app/presentation/pages/profile/profile_view.dart';
import 'package:test_app/presentation/pages/transactions/transactions_view.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

// ── Neo Brutalism tokens ────────────────────────────────────────────────────
const _kAccentYellow = Color(0xFFFFE600);
const _kNavBorder = BorderSide(color: Colors.black, width: 2.5);

class LandingView extends StatelessWidget {
  final int pageIndex;
  const LandingView({super.key, this.pageIndex = 0});

  static final List<Widget> pages = [
    const HomeView(),
    const TransactionsView(),
    const CategoriesView(),
    const BanksView(),
    const ProfileView(),
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
      {'icon': Icons.list_alt_rounded, 'label': 'TXS'},
      {'icon': Icons.grid_view_rounded, 'label': 'CATS'},
      {'icon': Icons.account_balance_wallet_rounded, 'label': 'BANK'},
      {'icon': Icons.person_rounded, 'label': 'ME'},
    ];

    return Obx(() {
      final currentIndex = controller.currentIndex.value;
      final isDark = Theme.of(context).brightness == .dark;
      final bg = isDark ? const Color(0xFF1A1A1A) : Colors.white;

      return Container(
        margin: const .only(left: 12, right: 12, bottom: 16),
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
                      Icon(
                        icon,
                        size: 22,
                        color: isSelected
                            ? Colors.black
                            : (isDark ? Colors.white54 : Colors.black38),
                      ),
                      3.hBox,
                      AppText(
                        label,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: isSelected ? .w900 : .w700,
                          letterSpacing: 0.5,
                          color: isSelected
                              ? Colors.black
                              : (isDark ? Colors.white38 : Colors.black38),
                        ),
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
