import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/core/helpers/screen_helper.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

class AppDialogs {
  static const _kAccentYellow = Color(0xFFFFE600);
  static const _kAccentGreen = Color(0xFF00C853);
  static const _kAccentRed = Color(0xFFFF1744);
  static const _kAccentBlue = Color(0xFF2979FF);
  // static const _kAccentPurple = Color(0xFF7C4DFF);

  /// Shows a Neo Brutalist Toast/Snackbar
  static void showSnackbar({
    required String message,
    String? title,
    bool isError = false,
    bool isSuccess = false,
  }) {
    final bgColor = isError
        ? _kAccentRed
        : isSuccess
        ? _kAccentGreen
        : _kAccentYellow;

    final textColor = (isError || isSuccess) ? Colors.white : Colors.black;

    Get.rawSnackbar(
      titleText: title != null
          ? AppText(
              title.toUpperCase(),
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w900,
                fontSize: 14,
                letterSpacing: 1.5,
              ),
            )
          : null,
      messageText: AppText(
        message.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
      backgroundColor: bgColor,
      margin: const EdgeInsets.all(16),
      borderRadius: 0,
      snackPosition: SnackPosition.TOP,
      borderWidth: 2.5,
      borderColor: Colors.black,
      boxShadows: [
        BoxShadow(
          color: Colors.black,
          offset: const Offset(5, 5),
          blurRadius: 0,
        ),
      ],
      duration: const Duration(seconds: 3),
    );
  }

  /// Shows a Neo Brutalist Confirmation Dialog
  static Future<bool?> showConfirmDialog({
    required String title,
    required String content,
    String confirmText = "CONFIRM",
    String cancelText = "CANCEL",
    bool isDestructive = false,
  }) async {
    return await Get.dialog<bool>(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: Get.width * 0.85,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 3),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(8, 8)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _kAccentYellow,
                    border: Border.all(color: Colors.black, width: 2.5),
                  ),
                  child: AppText(
                    title.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                AppText(
                  content.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    height: 1.5,
                  ),
                  align: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: _nbButton(
                        text: cancelText,
                        color: Colors.white,
                        onTap: () => Screen.close(result: false),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _nbButton(
                        text: confirmText,
                        color: isDestructive ? _kAccentRed : _kAccentBlue,
                        textColor: Colors.white,
                        onTap: () => Screen.close(result: true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _nbButton({
    required String text,
    required Color color,
    Color textColor = Colors.black,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black, width: 2.5),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(4, 4)),
          ],
        ),
        alignment: Alignment.center,
        child: AppText(
          text.toUpperCase(),
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w900,
            fontSize: 13,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
