import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../model/entity_room.dart';
import '../../../../../objectbox.g.dart';
import '../../../../../service/service_object_box.dart';
import '../../../model/model_task.dart';

class ActivityMaintenanceViewOnly extends StatelessWidget {
  final String roomUuid;
  const ActivityMaintenanceViewOnly({super.key, required this.roomUuid});

  String _formatDate(String? date) {
    if (date == null) return '-';
    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(date));
    } catch (_) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final boxTask = Get.find<ServiceObjectBox>().store.box<EntityTask>();
    late final boxRoom = Get.find<ServiceObjectBox>().store.box<EntityRoom>();

    final builder = boxTask.query(
      EntityTask_.taskType.equals("maintenance"),
    );

// Apply link filter
    builder.link(
      EntityTask_.room,
      EntityRoom_.roomUuid.equals(roomUuid),
    );

// Add ordering
    builder.order(
      EntityTask_.createdAt,
      flags: Order.descending,
    );

// Build and fetch
    final maintenanceList = builder.build().find();


    if (maintenanceList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Maintenance Info"),
        ),
        body: const Center(child: Text("No maintenance data found.")),
      );
    }

    final task = maintenanceList.first;
    final room = task.room.target;

    final assigned = task.assignedPerson != null
        ? [
      {"name": task.assignedPerson, "phone": task.mobileNumber}
    ]
        : [];

    final person = assigned.first;

    final start = _formatDate(task.startDate);
    final end = _formatDate(task.endDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Room Under Maintenance"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Room: ${room?.number}", style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),

                Text("🛠 Reason: ${task.reason ?? '-'}",
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),

                Text("📅 Start: $start", style: const TextStyle(fontSize: 16)),
                Text("📅 End: $end", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),

                Text("👷 Assigned: ${person["name"]} (${person["phone"]})",
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),

                Text("Created On: ${task.createdAt}",
                    style: const TextStyle(fontSize: 13, color: Colors.grey)),

                const Spacer(),

                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.close),
                    label: const Text("Close"),
                    onPressed: () => Get.back(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
