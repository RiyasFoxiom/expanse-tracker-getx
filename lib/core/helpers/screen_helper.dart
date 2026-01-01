import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class Screen {
//   static Future? open(Widget page) => Get.to(page, preventDuplicates: false,binding: null);

//   static Future? openClosingCurrent(Widget page) => Get.off(page);

//   static Future? openAsNewPage(Widget page) => Get.offAll(() => page);

//   static void close({Object? result}) => Get.back(result: result);

//   // static closeDialog({Object? result}) => Get.back(result: result);
// }
class Screen {
  static Future? open(Widget page, {Bindings? binding}) =>
      Get.to(() => page, preventDuplicates: false, binding: binding);

  static Future? openClosingCurrent(Widget page, {Bindings? binding}) =>
      Get.off(() => page, binding: binding);

  static Future? openAsNewPage(Widget page, {Bindings? binding}) =>
      Get.offAll(() => page, binding: binding);

  static void close({Object? result}) => Get.back(result: result);
}
