// lib/screens/room/maintenance/controller_maintenance.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../model/entity_maintenance.dart';
import '../../../model/entity_room.dart';
import '../../../service/service_object_box.dart';
import '../../../objectbox.g.dart';

class ControllerMaintenanceDialog extends GetxController {
  late final boxMaintenance =
  Get.find<ServiceObjectBox>().store.box<EntityMaintenance>();
  late final boxRoom = Get.find<ServiceObjectBox>().store.box<EntityRoom>();

  final RxList<EntityMaintenance> maintenanceList = <EntityMaintenance>[].obs;

  /// ✅ Load only this room's maintenance
  void loadMaintenanceByRoom(String roomUuid) {
    final results = boxMaintenance
        .query(EntityMaintenance_.roomUuid.equals(roomUuid))
        .order(EntityMaintenance_.createdOn, flags: Order.descending)
        .build()
        .find();

    maintenanceList.assignAll(results.take(1)); // only latest one
  }

  /// ✅ Open add maintenance dialog
  Future<void> showAddMaintenanceDialog(BuildContext context, String roomUuid) async {
    final reasonCtrl = TextEditingController();
    final assignedNameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    DateTime? startDate;
    DateTime? endDate;

    await Get.dialog(
      Material(
        type: MaterialType.transparency,
        child: AlertDialog(
          title: const Text("Add Maintenance Record"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: reasonCtrl,
                      decoration: const InputDecoration(
                        labelText: "Reason",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: assignedNameCtrl,
                      decoration: const InputDecoration(
                        labelText: "Assigned To (Name)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Mobile Number",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        "Start Date: ${startDate != null ? startDate!.toLocal().toString().split(' ')[0] : 'Select'}",
                      ),
                      trailing: const Icon(Icons.date_range),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2030),
                          initialDate: DateTime.now(),
                        );
                        if (picked != null) setState(() => startDate = picked);
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        "Expected End Date: ${endDate != null ? endDate!.toLocal().toString().split(' ')[0] : 'Select'}",
                      ),
                      trailing: const Icon(Icons.date_range_outlined),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2030),
                          initialDate: DateTime.now(),
                        );
                        if (picked != null) setState(() => endDate = picked);
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
                  Get.snackbar("Error", "Please fill all fields");
                  return;
                }

                // ✅ Create maintenance entry
                final entity = EntityMaintenance(
                  maintenanceUuid: const Uuid().v4(),
                  roomUuid: roomUuid,
                  reason: reasonCtrl.text,
                  startDate: startDate!.toIso8601String(),
                  endDate: endDate!.toIso8601String(),
                  createdOn: DateTime.now().toIso8601String(),
                  updatedOn: DateTime.now().toIso8601String(),
                  assignedPersons: jsonEncode([
                    {"name": assignedNameCtrl.text, "phone": phoneCtrl.text}
                  ]),
                );
                boxMaintenance.put(entity);

                // ✅ Block the room
                final room = boxRoom
                    .query(EntityRoom_.roomUuid.equals(roomUuid))
                    .build()
                    .findFirst();
                if (room != null) {
                  room.status = "blocked";
                  boxRoom.put(room);
                }

                loadMaintenanceByRoom(roomUuid);
                Get.back();
                Get.snackbar("Success", "Room set to maintenance mode");
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Mark maintenance as done (remove + room available)
  void markMaintenanceDone(String roomUuid) {
    // delete all maintenance for this room
    final query = boxMaintenance
        .query(EntityMaintenance_.roomUuid.equals(roomUuid))
        .build();
    final results = query.find();
    for (var r in results) {
      boxMaintenance.remove(r.maintenanceId);
    }

    // make room available again
    final room = boxRoom
        .query(EntityRoom_.roomUuid.equals(roomUuid))
        .build()
        .findFirst();
    if (room != null) {
      room.status = "available";
      boxRoom.put(room);
    }

    maintenanceList.clear();
    Get.snackbar("Done", "Room marked as available ✅");
  }
}
