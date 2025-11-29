import 'package:get/get.dart';
import '../../../../model/entity_room.dart';
import '../../../../model/model_task.dart';
import '../../../../objectbox.g.dart';
import '../../../../service/service_object_box.dart';

class ControllerMaintenanceHistory extends GetxController {
  late final boxTask = Get.find<ServiceObjectBox>().store.box<EntityTask>();
  late final boxRoom = Get.find<ServiceObjectBox>().store.box<EntityRoom>();

  final RxList<Map<String, dynamic>> maintenanceHistory =
      <Map<String, dynamic>>[].obs;

  /// Load all maintenance tasks OR room-specific tasks
  void loadMaintenanceHistory({String? roomUuid}) {
    final builder = boxTask.query(EntityTask_.taskType.equals("maintenance"));

    // filter by room relation
    if (roomUuid != null && roomUuid.isNotEmpty) {
      builder.link(EntityTask_.room, EntityRoom_.roomUuid.equals(roomUuid));
    }

    final results = builder
        .order(EntityTask_.createdAt, flags: Order.descending)
        .build()
        .find();

    final history = results.map((task) {
      final room = task.room.target;

      final assigned = task.assignedPerson != null
          ? [
              {"name": task.assignedPerson, "phone": task.mobileNumber},
            ]
          : [];

      return {'task': task, 'room': room, 'assigned': assigned};
    }).toList();

    maintenanceHistory.assignAll(history);
  }
}
