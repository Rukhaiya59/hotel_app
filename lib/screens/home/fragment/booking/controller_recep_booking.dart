import 'package:get/get.dart';
import 'package:hotel/model/entity_room.dart';
import 'package:hotel/service/service_object_box.dart';
import 'package:hotel/objectbox.g.dart';

class ControllerReceptionistBooking extends GetxController {
  late Box<EntityRoom> boxRoom;
  final RxList<EntityRoom> allRooms = <EntityRoom>[].obs;

  @override
  void onInit() {
    super.onInit();
    final ob = Get.find<ServiceObjectBox>();
    boxRoom = ob.store.box<EntityRoom>();
    fetchRooms();
  }

  void fetchRooms() {
    final rooms = boxRoom.getAll();
    allRooms.assignAll(rooms);
  }

  void updateRoomStatus(EntityRoom room, String status) {
    room.status = status.toLowerCase();
    boxRoom.put(room);
    fetchRooms();
  }
}
