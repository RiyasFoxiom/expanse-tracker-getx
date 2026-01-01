import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test_app/core/helpers/screen_helper.dart';
import 'package:test_app/domain/repositories/local_auth_repository.dart';
import 'package:test_app/presentation/pages/landing/landing_view.dart';

class SplashController extends GetxController {
  final LocalAuthRepository authRepository;

  SplashController(this.authRepository);

  @override
  void onInit() {
    super.onInit();
    _authenticateUser();
  }

  Future<void> _authenticateUser() async {
    await Future.delayed(const Duration(seconds: 1)); // Splash delay

    final bool isSupported;
    try {
      isSupported = await authRepository.isAuthAvailable(); // Uses isDeviceSupported()
    } catch (e) {
      debugPrint('Error checking auth support: $e');
      _goToLanding(); // Fallback to app on any error
      return;
    }

    // If device does NOT support any local auth (very rare, means no passcode even) → skip to app
    if (!isSupported) {
      _goToLanding();
      return;
    }

    // Device supports auth → show prompt (biometrics or fallback to passcode)
     bool isAuthenticated;
    try {
      isAuthenticated = await authRepository.authenticate();
    } catch (e) {
      debugPrint('Auth exception: $e');
      isAuthenticated = false;
    }

    if (isAuthenticated) {
      _goToLanding();
    } else {
      // User canceled, failed, or no credentials configured → close app
      SystemNavigator.pop();
    }
  }

  void _goToLanding() {
    Screen.openAsNewPage(const LandingView());
  }
}