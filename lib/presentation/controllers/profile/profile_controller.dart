import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:test_app/core/services/supabase_auth_service.dart';
import 'package:test_app/presentation/pages/auth/login_view.dart';
import 'package:test_app/core/helpers/screen_helper.dart';

class ProfileController extends GetxController {
  final box = GetStorage();

  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  final RxString appVersion = ''.obs;

  String get userEmail => SupabaseAuthService.to.userEmail;
  String get userDisplayName => SupabaseAuthService.to.userDisplayName;
  bool get isLoggedIn => SupabaseAuthService.to.isLoggedIn.value;

  @override
  void onInit() {
    super.onInit();

    final storedTheme = box.read('themeMode');

    if (storedTheme == 'light') {
      themeMode.value = ThemeMode.light;
    } else if (storedTheme == 'dark') {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.system;
    }

    Get.changeThemeMode(themeMode.value);
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    appVersion.value = 'v${info.version}';
  }

  void setTheme(ThemeMode mode) {
    themeMode.value = mode;

    if (mode == ThemeMode.light) {
      box.write('themeMode', 'light');
    } else if (mode == ThemeMode.dark) {
      box.write('themeMode', 'dark');
    } else {
      box.write('themeMode', 'system');
    }

    Get.changeThemeMode(mode);
  }

  Future<void> signOut() async {
    await SupabaseAuthService.to.signOut();
    Screen.openAsNewPage(const LoginView());
  }
}
