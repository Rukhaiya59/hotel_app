import 'package:get/get.dart';
import 'controller_splash.dart';

class BindingSplash extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControllerSplash());
  }
}
