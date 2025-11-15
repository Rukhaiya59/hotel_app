import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../model/entity_maintenance.dart';
import '../../../../../objectbox.g.dart';
import '../../../../../service/service_object_box.dart';

class ActivityMaintenanceViewOnly extends StatelessWidget {
  final String roomUuid;
  const ActivityMaintenanceViewOnly({super.key, required this.roomUuid});

  @override
  Widget build(BuildContext context) {
    final box = Get.find<ServiceObjectBox>().store.box<EntityMaintenance>();

    // ✅ Fetch latest maintenance for this room
    final maintenanceList = box
        .query(EntityMaintenance_.roomUuid.equals(roomUuid))
        .order(EntityMaintenance_.createdOn, flags: Order.descending)
        .build()
        .find();

    if (maintenanceList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Maintenance Info"),
          centerTitle: true,
        ),
        body: const Center(
          child: Text("No maintenance data found for this room."),
        ),
      );
    }

    final m = maintenanceList.first;
    final assigned = m.assignedPersons != null ? jsonDecode(m.assignedPersons!) : [];
    final person = assigned.isNotEmpty ? assigned.first : {};

    return Scaffold(
      appBar: AppBar(
        title: const Text("Room Under Maintenance"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Maintenance Details",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text("🛠 Reason: ${m.reason ?? '-'}",
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text("📅 Start Date: ${m.startDate?.split('T').first ?? '-'}",
                    style: const TextStyle(fontSize: 16)),
                Text("📅 End Date: ${m.endDate?.split('T').first ?? '-'}",
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text("👷 Assigned To: ${person['name'] ?? '-'} (${person['phone'] ?? '-'})",
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text("📞 Contact: ${m.mobilenumber ?? '-'}",
                    style: const TextStyle(fontSize: 16)),
                const Spacer(),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                    label: const Text("Close"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
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
