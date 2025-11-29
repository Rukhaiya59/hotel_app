import 'package:get/get.dart';
import 'package:hotel/model/entity_room.dart';
import 'package:hotel/objectbox.g.dart';
import 'package:hotel/service/service_object_box.dart';
import 'package:hotel/enums/enum_room_status.dart';

class ControllerOccupancy extends GetxController {
  late Box<EntityRoom> boxRoom;

  final RxInt totalRooms = 0.obs;
  final RxInt occupiedRooms = 0.obs;
  final RxInt vacantRooms = 0.obs;
  final RxInt cleaningRooms = 0.obs;
  final RxInt blockedRooms = 0.obs;

  final RxDouble occupancyPercent = 0.0.obs;
  final RxDouble vacancyPercent = 0.0.obs;

  @override
  void onInit() {
    final ob = Get.find<ServiceObjectBox>();
    boxRoom = ob.box<EntityRoom>();
    loadReport();
    super.onInit();
  }

  void loadReport() {
    final rooms = boxRoom.getAll();

    totalRooms.value = rooms.length;
    occupiedRooms.value = rooms
        .where((r) => r.status == EnumRoomStatus.busy.name)
        .length;

    vacantRooms.value = rooms
        .where((r) => r.status == EnumRoomStatus.available.name)
        .length;

    cleaningRooms.value = rooms
        .where((r) => r.status == EnumRoomStatus.cleaning.name)
        .length;

    blockedRooms.value = rooms
        .where((r) => r.status == EnumRoomStatus.blocked.name)
        .length;

    // Percentage
    if (totalRooms.value > 0) {
      occupancyPercent.value =
          (occupiedRooms.value / totalRooms.value) * 100;

      vacancyPercent.value =
          (vacantRooms.value / totalRooms.value) * 100;
    }
  }
}
