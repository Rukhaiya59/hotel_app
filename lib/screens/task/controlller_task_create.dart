import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/util/snackbar_util.dart';
import '../../model/entity_task.dart';
import '../../model/entity_user.dart';
import '../../objectbox.g.dart';
import '../../service/service_object_box.dart';
import '../home/fragment/task/controller_task.dart';

class ControllerTaskCreate extends GetxController {
  final boxTask = Get.find<ServiceObjectBox>().box<EntityTask>();
  final boxUser = Get.find<ServiceObjectBox>().box<EntityUser>();

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController timeRequired = TextEditingController();

  RxList<EntityUser> rxUsers = <EntityUser>[].obs;
  Rx<EntityUser?> selectedUser = Rx<EntityUser?>(null);

  @override
  void onInit() {
    loadStaff();
    super.onInit();
  }

  Future<void> loadStaff() async {
    final query = boxUser.query(EntityUser_.role.equals("Housekeeping")).build();
    rxUsers.value = query.find();
    if (rxUsers.isNotEmpty) selectedUser.value = rxUsers.first;
  }


  void saveTask() {
    if (title.text.isEmpty ||
        description.text.isEmpty ||
        timeRequired.text.isEmpty ||
        selectedUser.value == null) {
      SnackbarUtil.showError("Please fill all fields");
      return;
    }

    final task = EntityTask(
      title: title.text,
      description: description.text,
      timeRequired: timeRequired.text,
      assignedToUuid: selectedUser.value!.userUuid,
      assignedToName: "${selectedUser.value!.first} ${selectedUser.value!.last}",
      createdAt: DateTime.now().toUtc(),
    );

    boxTask.put(task);
    if (Get.isRegistered<ControllerTask>()) {
      Get.find<ControllerTask>().loadTasks();
    }
    Get.back();
    SnackbarUtil.showSuccess("Success,Task assigned to ${task.assignedToName}",
        );
  }
  //
  // void createCleaningTaskForRoom(EntityRoom room) {
  //   // auto-assign to first housekeeping staff, if available
  //   final housekeepingStaff = rxUsers.firstWhereOrNull(
  //         (user) => user.role?.toLowerCase().contains('housekeeping') ?? false,
  //   );
  //
  //   if (housekeepingStaff == null) {
  //     debugPrint("No housekeeping staff found!");
  //     SnackbarUtil.showError("No housekeeping staff found!");
  //     return;
  //   }
  //
  //   final task = EntityTask(
  //     title: "Clean Room ${room.number}",
  //     description: "Clean and prepare the room for the next guest.",
  //     timeRequired: "30 mins",
  //     assignedToUuid: housekeepingStaff.userUuid,
  //     assignedToName:
  //     "${housekeepingStaff.first} ${housekeepingStaff.last}",
  //     createdAt: DateTime.now().toUtc(),
  //   );
  //
  //   boxTask.put(task);
  //   debugPrint("Cleaning task created for room ${room.number}");
  //
  //   if (Get.isRegistered<ControllerTask>()) {
  //     Get.find<ControllerTask>().loadTasks();
  //   }
  // }

}
