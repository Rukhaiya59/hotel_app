import 'dart:convert';
import 'package:get/get.dart';
import '../../../../model/entity_maintenance.dart';
import '../../../../model/entity_room.dart';
import '../../../../objectbox.g.dart';
import '../../../../service/service_object_box.dart';

class FragControllerMaintenance extends GetxController {
  late final boxMaintenance =
  Get.find<ServiceObjectBox>().store.box<EntityMaintenance>();
  late final boxRoom = Get.find<ServiceObjectBox>().store.box<EntityRoom>();

  final RxList<Map<String, dynamic>> maintenanceHistory = <Map<String, dynamic>>[].obs;

  /// Load all maintenance records (or filter by roomUuid)
  void loadMaintenanceHistory({String? roomUuid}) {
    final queryBuilder = roomUuid != null && roomUuid.isNotEmpty
        ? boxMaintenance.query(EntityMaintenance_.roomUuid.equals(roomUuid))
        : boxMaintenance.query();

    final results = queryBuilder
        .order(EntityMaintenance_.createdOn, flags: Order.descending)
        .build()
        .find();

    final history = results.map((m) {
      final room = m.roomUuid != null
          ? boxRoom.query(EntityRoom_.roomUuid.equals(m.roomUuid!)).build().findFirst()
          : null;

      final assigned = m.assignedPersons != null
          ? jsonDecode(m.assignedPersons!)
          : [];

      return {
        'maintenance': m,
        'room': room,
        'assigned': assigned,
      };
    }).toList();

    maintenanceHistory.assignAll(history);
  }
}