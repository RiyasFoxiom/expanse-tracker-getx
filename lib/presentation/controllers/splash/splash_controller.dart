import 'package:get/get.dart';
import 'package:test_app/core/helpers/screen_helper.dart';
import 'package:test_app/core/services/supabase_auth_service.dart';
import 'package:test_app/domain/repositories/local_auth_repository.dart';
import 'package:test_app/presentation/pages/auth/login_view.dart';
import 'package:test_app/presentation/pages/landing/landing_view.dart';

class SplashController extends GetxController {
  final LocalAuthRepository authRepository;

  SplashController(this.authRepository);

  @override
  void onInit() {
    super.onInit();
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    // Show the splash screen for at least 1.5 seconds
    await Future.delayed(const Duration(milliseconds: 1500));

    final authService = SupabaseAuthService.to;

    if (authService.hasSession) {
      // User is already logged in – go straight to the app
      _goToLanding();
    } else {
      // No active session – show login
      _goToLogin();
    }
  }

  void _goToLanding() {
    Screen.openAsNewPage(const LandingView());
  }

  void _goToLogin() {
    Screen.openAsNewPage(const LoginView());
  }
}
