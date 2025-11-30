import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/entity_cleaning_task.dart';
import 'cleaning_controller.dart';

class FragHousekeepingHistory extends StatelessWidget {
  const FragHousekeepingHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HousekeepingHistoryController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cleaning History"),
        actions: [
          IconButton(
            onPressed: controller.loadHistory,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        final list = controller.rxHistory;

        if (list.isEmpty) {
          return const Center(
            child: Text("No cleaning history found"),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final task = list[index];
            final room = task.room.target;
            final staff = task.user.target;

            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(14),
                title: Text(
                  "Room ${room?.number ?? '-'}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Staff: ${staff?.first ?? staff?.username ?? 'Unknown'}"),
                      Text("Type: ${task.type}"),
                      Text("Assigned: ${task.createdAt}"),
                      Text("Completed: ${task.completedAt}"),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
