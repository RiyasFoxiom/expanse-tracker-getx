import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/presentation/controllers/auth/auth_controller.dart';
import 'package:test_app/presentation/pages/auth/signup_view.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

// ── Neo Brutalism tokens ────────────────────────────────────────────────────
const _kAccentYellow = Color(0xFFFFE600);
const _kAccentRed = Color(0xFFFF3B30);
const _kBorder = BorderSide(color: Colors.black, width: 2.5);
const _kShadow = BoxShadow(color: Colors.black, offset: Offset(5, 5), blurRadius: 0);

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F5F0);
    final cardBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: controller.loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                40.hBox,

                // ── Logo Block ─────────────────────────────────────────────
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: const BoxDecoration(
                          color: _kAccentYellow,
                          border: Border.fromBorderSide(_kBorder),
                          boxShadow: [_kShadow],
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 44,
                          color: Colors.black,
                        ),
                      ),
                      20.hBox,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white : Colors.black,
                          border: Border.all(
                            color: isDark ? Colors.white : Colors.black,
                            width: 2,
                          ),
                        ),
                        child: AppText(
                          'BUDGET TRACKER',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: isDark ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                      10.hBox,
                      AppText(
                        'SIGN IN TO CONTINUE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),

                44.hBox,

                // ── Card ───────────────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardBg,
                    border: const Border.fromBorderSide(_kBorder),
                    boxShadow: const [_kShadow],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header label
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        color: _kAccentYellow,
                        child: const AppText(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      20.hBox,

                      // ── Email ──────────────────────────────────────────
                      _FieldLabel('EMAIL ADDRESS', isDark),
                      8.hBox,
                      _BrutalTextField(
                        controller: controller.loginEmailCtrl,
                        isDark: isDark,
                        hint: 'enter@email.com',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.mail_outline_rounded,
                        validator: controller.validateEmail,
                      ),

                      16.hBox,

                      // ── Password ───────────────────────────────────────
                      _FieldLabel('PASSWORD', isDark),
                      8.hBox,
                      Obx(
                        () => _BrutalTextField(
                          controller: controller.loginPasswordCtrl,
                          isDark: isDark,
                          hint: '••••••••',
                          obscureText: controller.loginObscure.value,
                          prefixIcon: Icons.lock_outline_rounded,
                          validator: controller.validatePassword,
                          suffixIcon: controller.loginObscure.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          onSuffixTap: () => controller.loginObscure.toggle(),
                        ),
                      ),

                      20.hBox,

                      // ── Login Button ───────────────────────────────────
                      Obx(
                        () => _BrutalButton(
                          label: 'SIGN IN',
                          isLoading: controller.isLoginLoading.value,
                          accentColor: _kAccentYellow,
                          textColor: Colors.black,
                          onTap: controller.login,
                        ),
                      ),
                    ],
                  ),
                ),

                28.hBox,

                // ── Sign Up Link ───────────────────────────────────────────
                Center(
                  child: GestureDetector(
                    onTap: () => Get.to(() => const SignUpView()),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "DON'T HAVE AN ACCOUNT? ",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white38 : Colors.black38,
                              letterSpacing: 0.5,
                            ),
                          ),
                          TextSpan(
                            text: 'REGISTER',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : Colors.black,
                              letterSpacing: 0.5,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                20.hBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Reusable brutal label ────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String text;
  final bool isDark;
  const _FieldLabel(this.text, this.isDark);

  @override
  Widget build(BuildContext context) {
    return AppText(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
        color: isDark ? Colors.white60 : Colors.black54,
      ),
    );
  }
}

// ── Reusable brutal text field ───────────────────────────────────────────────
class _BrutalTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final String? Function(String?)? validator;

  const _BrutalTextField({
    required this.controller,
    required this.isDark,
    required this.hint,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.onSuffixTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final fieldBg = isDark ? const Color(0xFF111111) : const Color(0xFFF1F3F8);
    final borderColor = isDark ? Colors.white24 : Colors.black;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? Colors.white24 : Colors.black26,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: fieldBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: borderColor, width: 2.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: borderColor, width: 2.5),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: _kAccentYellow, width: 2.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: _kAccentRed, width: 2.5),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: _kAccentRed, width: 2.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        prefixIcon: Icon(prefixIcon, size: 20, color: isDark ? Colors.white38 : Colors.black38),
        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: onSuffixTap,
                child: Icon(suffixIcon, size: 20, color: isDark ? Colors.white38 : Colors.black38),
              )
            : null,
        errorStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          color: _kAccentRed,
        ),
      ),
    );
  }
}

// ── Reusable brutal button ───────────────────────────────────────────────────
class _BrutalButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final Color accentColor;
  final Color textColor;
  final VoidCallback onTap;

  const _BrutalButton({
    required this.label,
    required this.isLoading,
    required this.accentColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: isLoading ? accentColor.withValues(alpha: 0.6) : accentColor,
          border: const Border.fromBorderSide(_kBorder),
          boxShadow: isLoading
              ? null
              : const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.black,
                  ),
                )
              : Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: textColor,
                  ),
                ),
        ),
      ),
    );
  }
}
