import 'package:get/get.dart';
import 'package:test_app/presentation/controllers/landing/landing_controller.dart';

class LandingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LandingController());
    
  }
}
