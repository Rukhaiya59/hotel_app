import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/text_bold.dart';
import '../../../../widgets/text_small.dart';
import 'controller_maintenance_history.dart';

class ActivityMaintenanceHistory extends StatelessWidget {
  final String? roomUuid;
  ActivityMaintenanceHistory({super.key, this.roomUuid});

  final RxString query = "".obs; // SEARCH TEXT

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return "-";
    try {
      return date.split("T").first;
    } catch (_) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ControllerMaintenanceHistory());

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

      body: Column(
        children: [
          // SEARCH BAR -----------------------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: TextField(
              onChanged: (v) => query.value = v.toLowerCase(),
              decoration: InputDecoration(
                hintText: "Search by room, reason or person...",
                filled: true,
                fillColor: Theme.of(context).cardColor.withOpacity(0.12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),

          // HISTORY LIST --------------------------------------------------
          Expanded(
            child: Obx(() {
              final rawList = controller.maintenanceHistory;

              // FILTERED LIST (NO LOGIC CHANGE)
              final filtered = rawList.where((data) {
                final task = data['task'];
                final room = data['room'];
                final assigned = (data['assigned'] as List?) ?? [];
                final q = query.value;

                if (q.isEmpty) return true;

                // room number safe string
                final roomNumber =
                (room?.number?.toString() ?? '').toLowerCase();

                // reason safe string
                final reason =
                (task.reason ?? '').toLowerCase();

                // assigned person name safe string
                final personName = assigned.isNotEmpty
                    ? (assigned.first['name'] ?? '').toString().toLowerCase()
                    : '';

                return roomNumber.contains(q) ||
                    reason.contains(q) ||
                    personName.contains(q);
              }).toList();

              if (filtered.isEmpty) {
                return const Center(child: Text("No matching results."));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final data = filtered[index];
                  final task = data['task'];
                  final assigned = data['assigned'];
                  final room = data['room'];
                  final person = assigned.isNotEmpty ? assigned.first : {};

                  final start = _formatDate(task.startDate);
                  final end = _formatDate(task.endDate);

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (room != null)
                            TextBold(
                                message: "Room: ${room.number ?? '-'}", style:(TextStyle()),),
                          const SizedBox(height: 5),

                          TextSmall(
                              message: "Floor: ${room?.floor ?? '-'}", style: TextStyle(),),
                          const Divider(),

                          // CLEANED, NO EMOJIS
                          Text(
                            "Reason: ${task.reason ?? '-'}",
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 4),

                          Text("Start: $start",
                              style: const TextStyle(fontSize: 14)),
                          Text("End: $end",
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 4),

                          Text(
                            "Assigned: ${person['name'] ?? '-'} (${person['phone'] ?? '-'})",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 6),

                          Text(
                            "Created On: ${task.createdAt}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color
                                  ?.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
