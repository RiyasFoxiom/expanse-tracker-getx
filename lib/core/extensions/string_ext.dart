import 'package:flutter/material.dart';

extension StringExtension on String {
  String get upperFirst =>
      length > 1 ? "${this[0].toUpperCase()}${substring(1)}" : toUpperCase();

  String get getFirstLetter =>
      length > 1 ? this[0].toUpperCase() : toUpperCase();
}

extension FocusNodeExtension on FocusNode {
  void safeUnfocus() {
    if (hasFocus) {
      unfocus();
    }
  }
}
