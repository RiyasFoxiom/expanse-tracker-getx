import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test_app/core/helpers/screen_helper.dart';
import 'package:test_app/core/services/supabase_auth_service.dart';
import 'package:test_app/presentation/pages/landing/landing_view.dart';

class AuthController extends GetxController {
  final SupabaseAuthService _authService = SupabaseAuthService.to;

  // ── Form Keys ─────────────────────────────────────────────────────────────
  final loginFormKey = GlobalKey<FormState>();
  final signUpFormKey = GlobalKey<FormState>();

  // ── Text controllers ──────────────────────────────────────────────────────
  final loginEmailCtrl = TextEditingController();
  final loginPasswordCtrl = TextEditingController();
  final signUpEmailCtrl = TextEditingController();
  final signUpNameCtrl = TextEditingController();
  final signUpPasswordCtrl = TextEditingController();
  final signUpConfirmPasswordCtrl = TextEditingController();

  // ── Reactive state ────────────────────────────────────────────────────────
  final RxBool isLoginLoading = false.obs;
  final RxBool isSignUpLoading = false.obs;
  final RxBool loginObscure = true.obs;
  final RxBool signUpObscure = true.obs;
  final RxBool signUpConfirmObscure = true.obs;

  @override
  void onClose() {
    loginEmailCtrl.dispose();
    loginPasswordCtrl.dispose();
    signUpEmailCtrl.dispose();
    signUpNameCtrl.dispose();
    signUpPasswordCtrl.dispose();
    signUpConfirmPasswordCtrl.dispose();
    super.onClose();
  }

  // ── Validators ────────────────────────────────────────────────────────────
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'EMAIL IS REQUIRED';
    if (!GetUtils.isEmail(value.trim())) return 'ENTER A VALID EMAIL';
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'NAME IS REQUIRED';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'PASSWORD IS REQUIRED';
    if (value.length < 8) return 'MINIMUM 8 CHARACTERS REQUIRED';
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'PLEASE CONFIRM YOUR PASSWORD';
    if (value != signUpPasswordCtrl.text) return 'PASSWORDS DO NOT MATCH';
    return null;
  }

  // ── Login ─────────────────────────────────────────────────────────────────
  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;
    isLoginLoading.value = true;
    try {
      final response = await _authService.signIn(
        email: loginEmailCtrl.text.trim(),
        password: loginPasswordCtrl.text,
      );
      if (response.user != null) {
        _goToApp();
        Future.delayed(const Duration(milliseconds: 500), 
            () => _showSuccess('WELCOME BACK!'));
      }
    } on AuthException catch (e) {
      _showError(_mapAuthError(e.message));
    } catch (_) {
      _showError('SOMETHING WENT WRONG. TRY AGAIN.');
    } finally {
      isLoginLoading.value = false;
    }
  }

  // ── Sign Up ───────────────────────────────────────────────────────────────
  Future<void> signUp() async {
    if (!signUpFormKey.currentState!.validate()) return;
    isSignUpLoading.value = true;
    try {
      final response = await _authService.signUp(
        email: signUpEmailCtrl.text.trim(),
        password: signUpPasswordCtrl.text,
        name: signUpNameCtrl.text.trim(),
      );
      if (response.session != null) {
        // Auto-login successful (if email confirmation is turned off in Supabase)
        _goToApp();
        Future.delayed(const Duration(milliseconds: 500), 
            () => _showSuccess('ACCOUNT CREATED SUCCESSFULLY!'));
      } else if (response.user != null) {
        // Fallback if email confirmation is turned on
        _showSuccess('ACCOUNT CREATED! CHECK YOUR EMAIL TO VERIFY.');
        Get.back(); // Go back to login
      }
    } on AuthException catch (e) {
      _showError(_mapAuthError(e.message));
    } catch (_) {
      _showError('SOMETHING WENT WRONG. TRY AGAIN.');
    } finally {
      isSignUpLoading.value = false;
    }
  }

  // ── Sign Out ──────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    await _authService.signOut();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  void _goToApp() {
    Screen.openAsNewPage(const LandingView());
  }

  void _showSuccess(String msg) {
    Get.snackbar(
      '✓ SUCCESS',
      msg,
      backgroundColor: const Color(0xFF00C853),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
    );
  }

  void _showError(String msg) {
    Get.snackbar(
      '✗ ERROR',
      msg,
      backgroundColor: const Color(0xFFDD2222),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(12),
    );
  }

  String _mapAuthError(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('invalid login credentials') ||
        lower.contains('invalid credentials')) {
      return 'INVALID EMAIL OR PASSWORD';
    }
    if (lower.contains('email not confirmed')) {
      return 'PLEASE VERIFY YOUR EMAIL FIRST';
    }
    if (lower.contains('user already registered') ||
        lower.contains('already registered')) {
      return 'THIS EMAIL IS ALREADY REGISTERED';
    }
    if (lower.contains('password should be at least')) {
      return 'PASSWORD MUST BE AT LEAST 8 CHARACTERS';
    }
    if (lower.contains('network') || lower.contains('socket')) {
      return 'NO INTERNET CONNECTION';
    }
    return message.toUpperCase();
  }
}
