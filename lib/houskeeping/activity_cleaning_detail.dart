import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/entity_cleaning_task.dart';
import '../../model/entity_room.dart';
import '../../service/service_object_box.dart';
import '../../objectbox.g.dart';

class ActivityCleaningDetail extends StatelessWidget {
  final String roomUuid;
  const ActivityCleaningDetail({
    super.key,
    required this.roomUuid,
  });
  @override
  Widget build(BuildContext context) {
    final boxTask = Get.find<ServiceObjectBox>().box<EntityCleaningTask>();
    final boxRoom = Get.find<ServiceObjectBox>().box<EntityRoom>();

    final room = boxRoom
        .query(EntityRoom_.roomUuid.equals(roomUuid))
        .build()
        .findFirst();

    final task = boxTask
        .query(EntityCleaningTask_.status.equals("pending"))
        .build()
        .find()
        .firstWhere(
          (t) => t.room.target?.roomUuid == roomUuid,
      orElse: () => EntityCleaningTask(status: "", type: ""),
    );

    if (room == null || task.id == 0) {
      return Scaffold(
        appBar: AppBar(title: const Text("Cleaning Detail")),
        body: const Center(child: Text("No active cleaning task found")),
      );
    }

    final staff = task.user.target;

    return Scaffold(
      appBar: AppBar(
        title: Text("Room ${room.number} - Cleaning"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _row("Room Number", room.number ?? "-"),
                _row("Cleaning Type", task.type),
                _row(
                  "Assigned Staff",
                  "${staff?.first ?? ''} ${staff?.last ?? ''}".trim(),
                ),
                _row("Task Status", task.status),
                _row(
                  "Assigned At",
                  task.createdAt?.toString() ?? "-",
                ),

                const Spacer(),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
