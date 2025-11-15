import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../model/entity_maintenance.dart';
import '../../../../widgets/text_bold.dart';
import '../../../../widgets/text_small.dart';
import 'frag_controller_maintenance.dart';

class FragHomeMaintenance extends StatelessWidget {
  final String? roomUuid;
  const FragHomeMaintenance({super.key, this.roomUuid});

  @override
  Widget build(BuildContext context) {
    final FragControllerMaintenance controller =
    Get.put(FragControllerMaintenance());

    // 🟢 Load all records or room-specific records
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadMaintenanceHistory(roomUuid: roomUuid);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(roomUuid == null
            ? "All Maintenance History"
            : "Room Maintenance History"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                controller.loadMaintenanceHistory(roomUuid: roomUuid),
          ),
        ],
      ),
      body: Obx(() {
        final history = controller.maintenanceHistory;
        if (history.isEmpty) {
          return const Center(
            child: Text("No maintenance records found."),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: history.length,
          itemBuilder: (context, index) {
            final data = history[index];
            final EntityMaintenance m = data['maintenance'];
            final assigned = data['assigned'] as List;
            final room = data['room'];
            final person = assigned.isNotEmpty ? assigned.first : {};

            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (room != null)
                      TextBold(message: "Room: ${room.number ?? '-'}"),
                    const SizedBox(height: 5),
                    TextSmall(message: "Floor: ${room?.floor ?? '-'}"),
                    const Divider(),
                    Text("🛠 Reason: ${m.reason ?? '-'}",
                        style: const TextStyle(fontSize: 15)),
                    Text("📅 Start: ${m.startDate?.split('T').first ?? '-'}"),
                    Text("📅 End: ${m.endDate?.split('T').first ?? '-'}"),
                    Text("👷 Assigned: ${person['name'] ?? '-'} (${person['phone'] ?? '-'})"),
                    const SizedBox(height: 5),
                    Text(
                      "Created On: ${m.createdOn?.split('T').first ?? '-'}",
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}