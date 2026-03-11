import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/presentation/controllers/auth/auth_controller.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

// ── Neo Brutalism tokens ────────────────────────────────────────────────────
const _kAccentYellow = Color(0xFFFFE600);
const _kAccentBlue = Color(0xFF2979FF);
const _kAccentRed = Color(0xFFFF3B30);
const _kBorder = BorderSide(color: Colors.black, width: 2.5);
const _kShadow = BoxShadow(
  color: Colors.black,
  offset: Offset(5, 5),
  blurRadius: 0,
);

class SignUpView extends GetView<AuthController> {
  const SignUpView({super.key});

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
            key: controller.signUpFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Back button ────────────────────────────────────────────
                GestureDetector(
                  onTap: Get.back,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                      border: const Border.fromBorderSide(_kBorder),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(3, 3),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: isDark ? Colors.white : Colors.black,
                      size: 20,
                    ),
                  ),
                ),

                32.hBox,

                // ── Header ─────────────────────────────────────────────────
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: const BoxDecoration(
                          color: _kAccentBlue,
                          border: Border.fromBorderSide(_kBorder),
                          boxShadow: [_kShadow],
                        ),
                        child: const Icon(
                          Icons.person_add_rounded,
                          size: 44,
                          color: Colors.white,
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
                          'CREATE ACCOUNT',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: isDark ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                      10.hBox,
                      AppText(
                        'START TRACKING YOUR EXPENSES',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),

                36.hBox,

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
                        color: _kAccentBlue,
                        child: const AppText(
                          'REGISTER',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      20.hBox,

                      // ── Name ───────────────────────────────────────────
                      _FieldLabel('DISPLAY NAME', isDark),
                      8.hBox,
                      _BrutalTextField(
                        controller: controller.signUpNameCtrl,
                        isDark: isDark,
                        hint: 'TEST USER',
                        prefixIcon: Icons.person_outline_rounded,
                        validator: controller.validateName,
                      ),

                      16.hBox,

                      // ── Email ──────────────────────────────────────────
                      _FieldLabel('EMAIL ADDRESS', isDark),
                      8.hBox,
                      _BrutalTextField(
                        controller: controller.signUpEmailCtrl,
                        isDark: isDark,
                        hint: 'enter@email.com',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.mail_outline_rounded,
                        validator: controller.validateEmail,
                      ),

                      16.hBox,

                      // ── Password ───────────────────────────────────────
                      _FieldLabel('PASSWORD (MIN. 8 CHARACTERS)', isDark),
                      8.hBox,
                      Obx(
                        () => _BrutalTextField(
                          controller: controller.signUpPasswordCtrl,
                          isDark: isDark,
                          hint: '••••••••',
                          obscureText: controller.signUpObscure.value,
                          prefixIcon: Icons.lock_outline_rounded,
                          validator: controller.validatePassword,
                          suffixIcon: controller.signUpObscure.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          onSuffixTap: () => controller.signUpObscure.toggle(),
                        ),
                      ),

                      16.hBox,

                      // ── Confirm password ───────────────────────────────
                      _FieldLabel('CONFIRM PASSWORD', isDark),
                      8.hBox,
                      Obx(
                        () => _BrutalTextField(
                          controller: controller.signUpConfirmPasswordCtrl,
                          isDark: isDark,
                          hint: '••••••••',
                          obscureText: controller.signUpConfirmObscure.value,
                          prefixIcon: Icons.lock_person_outlined,
                          validator: controller.validateConfirmPassword,
                          suffixIcon: controller.signUpConfirmObscure.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          onSuffixTap:
                              () => controller.signUpConfirmObscure.toggle(),
                        ),
                      ),

                      // ── Password hint ──────────────────────────────────
                      8.hBox,
                      Row(
                        children: [
                          Container(
                            width: 3,
                            height: 12,
                            color: _kAccentYellow,
                          ),
                          8.wBox,
                          AppText(
                            'PASSWORD MUST BE AT LEAST 8 CHARACTERS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: isDark ? Colors.white38 : Colors.black38,
                            ),
                          ),
                        ],
                      ),

                      24.hBox,

                      // ── Register Button ────────────────────────────────
                      Obx(
                        () => _BrutalButton(
                          label: 'CREATE ACCOUNT',
                          isLoading: controller.isSignUpLoading.value,
                          accentColor: _kAccentBlue,
                          textColor: Colors.white,
                          onTap: controller.signUp,
                        ),
                      ),
                    ],
                  ),
                ),

                28.hBox,

                // ── Login Link ─────────────────────────────────────────────
                Center(
                  child: GestureDetector(
                    onTap: Get.back,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'ALREADY HAVE AN ACCOUNT? ',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white38 : Colors.black38,
                              letterSpacing: 0.5,
                            ),
                          ),
                          TextSpan(
                            text: 'SIGN IN',
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
        prefixIcon: Icon(
          prefixIcon,
          size: 20,
          color: isDark ? Colors.white38 : Colors.black38,
        ),
        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: onSuffixTap,
                child: Icon(
                  suffixIcon,
                  size: 20,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
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
                    color: Colors.white,
                  ),
                )
              : Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
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
