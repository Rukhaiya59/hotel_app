import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/util/snackbar_util.dart';
import '../../../enums/enum_room_status.dart';
import '../../../model/entity_room.dart';
import '../../../model/model_task.dart';
import '../../../objectbox.g.dart';
import '../../../service/service_object_box.dart';


class ControllerMaintenanceDialog extends GetxController {
  late final Box<EntityTask> boxTask =
  Get.find<ServiceObjectBox>().store.box<EntityTask>();
  late final Box<EntityRoom> boxRoom =
  Get.find<ServiceObjectBox>().store.box<EntityRoom>();

  final RxList<EntityTask> maintenanceList = <EntityTask>[].obs;

  /// Load latest maintenance for room
  void loadMaintenanceByRoom(String roomUuid) {
    // create a QueryBuilder first
    final qb = boxTask.query(EntityTask_.taskType.equals("maintenance"))
      ..link(EntityTask_.room, EntityRoom_.roomUuid.equals(roomUuid))
      ..order(EntityTask_.createdAt, flags: Order.descending);

    // build the query (this returns a BuiltQuery / Query object)
    final query = qb.build();

    // find results and close the built query
    final results = query.find();
    query.close();

    maintenanceList.assignAll(results.take(1));
  }

  /// Add maintenance task
  Future<void> showAddMaintenanceDialog(
      BuildContext context, String roomUuid) async {
    final reasonCtrl = TextEditingController();
    final assignedCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final expenseCtrl = TextEditingController();
    final expenseNoteCtrl = TextEditingController();

    DateTime? startDate;
    DateTime? endDate;

    await Get.dialog(
      AlertDialog(
        title: const Text("Add Maintenance"),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: reasonCtrl,
                    decoration: const InputDecoration(
                        labelText: "Reason", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: assignedCtrl,
                    decoration: const InputDecoration(
                        labelText: "Assigned Person",
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        labelText: "Mobile Number",
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: expenseCtrl,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                        labelText: "Expense Amount",
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: expenseNoteCtrl,
                    decoration: const InputDecoration(
                        labelText: "Expense Note",
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    title: Text(
                      "Start Date: ${startDate != null ? startDate!.toLocal().toString().split(' ')[0] : 'Select'}",
                    ),
                    trailing: const Icon(Icons.date_range),
                    onTap: () async {
                      final pick = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (pick != null) setState(() => startDate = pick);
                    },
                  ),
                  ListTile(
                    title: Text(
                      "End Date: ${endDate != null ? endDate!.toLocal().toString().split(' ')[0] : 'Select'}",
                    ),
                    trailing: const Icon(Icons.date_range),
                    onTap: () async {
                      final pick = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (pick != null) setState(() => endDate = pick);
                    },
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (reasonCtrl.text.isEmpty ||
                  startDate == null ||
                  endDate == null) {
                SnackbarUtil.showError("Error" "Please fill all required fields");
                return;
              }

              final task = EntityTask(
                taskType: "maintenance",
                status: "pending",
                reason: reasonCtrl.text,
                startDate: startDate!.toIso8601String(),
                endDate: endDate!.toIso8601String(),
                assignedPerson: assignedCtrl.text,
                mobileNumber: phoneCtrl.text,
                expenseAmount: double.tryParse(expenseCtrl.text),
                expenseNote: expenseNoteCtrl.text,
              );

              // link room (find by roomUuid)
              final room = boxRoom
                  .query(EntityRoom_.roomUuid.equals(roomUuid))
                  .build()
                  .findFirst();

              if (room != null) {
                task.room.target = room;
                // block the room
                room.status = "blocked";
                boxRoom.put(room);
              }

              // save task
              boxTask.put(task);

              loadMaintenanceByRoom(roomUuid);
              Get.back();
              Get.snackbar("Success", "Maintenance added");
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  /// Mark maintenance done
  void markMaintenanceDone(String roomUuid) {
    final qb = boxTask.query(EntityTask_.taskType.equals("maintenance"))
      ..link(EntityTask_.room, EntityRoom_.roomUuid.equals(roomUuid));

    final query = qb.build();
    final results = query.find();
    query.close();

    for (var t in results) {
      t.status = "done";
      boxTask.put(t);
    }

    final room = boxRoom
        .query(EntityRoom_.roomUuid.equals(roomUuid))
        .build()
        .findFirst();

    // if (room != null) {
    //   room.status = "available";
    //   boxRoom.put(room);
    // }
    if (room != null) {
      // ✔ After cleaning → room must be free
      room.status = EnumRoomStatus.available.name;
      room.bookingUuid = null;

      boxRoom.put(room);
    }

    maintenanceList.clear();
    SnackbarUtil.showSuccess( "Maintenance completed");
  }
}
