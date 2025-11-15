import 'package:get/get.dart';
import '../../service/service_object_box.dart';
import 'controller_create_room.dart';
import 'controller_room.dart';

class BindingRooms extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ServiceObjectBox());
    Get.lazyPut(() => ControllerRoom());
    Get.lazyPut(() => ControllerCreateRoom());
  }
}
