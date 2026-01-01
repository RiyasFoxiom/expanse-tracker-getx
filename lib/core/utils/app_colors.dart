import 'dart:ui';

import 'package:get/get.dart';

class AppColors {
  static Color get primaryText => Get.isDarkMode
      ? DartThemeColors.primaryText
      : LightThemeColors.primaryText;
}

class LightThemeColors {
  static const primaryText = Color(0xFF212121);
}

class DartThemeColors {
  static const primaryText = Color(0xFFE0E0E0);
}
