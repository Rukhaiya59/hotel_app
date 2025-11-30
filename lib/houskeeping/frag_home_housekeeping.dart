import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/entity_user.dart';
import '../../model/entity_room.dart';
import '../../model/entity_cleaning_task.dart';
import '../../service/service_object_box.dart';
import '../screens/booking/activity_booking.dart';
import 'dialog_housekeeping.dart';
import 'houskeeping_controller.dart';

class FragHomeHousekeeping extends StatelessWidget {
  const FragHomeHousekeeping({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HousekeepingController());

    final boxRoom = Get.find<ServiceObjectBox>().box<EntityRoom>();
    final rooms = boxRoom.getAll();
    for (var r in rooms) {
      debugPrint("ROOM ${r.number} STATUS = '${r.status}'");
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Housekeeping Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshAll,
          )
        ],
      ),
      body: Obx(() {
        final staff = controller.rxStaff;
        final busyStaff =
        staff.where((u) => controller.isBusy(u)).toList();
        final availableStaff =
        staff.where((u) => !controller.isBusy(u)).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _sectionTitle("Available Staff"),
              ...availableStaff.map(
                    (u) => _staffCard(context, controller, u, false),
              ),

              const SizedBox(height: 25),

              _sectionTitle("Busy Staff"),
              ...busyStaff.map(
                    (u) => _staffCard(context, controller, u, true),
              ),

              const SizedBox(height: 25),

              _sectionTitle("Rooms Under Cleaning"),
              Obx(() {
                return Column(
                  children: controller.rxCleaningRooms.map((room) {
                    final task = controller.rxActiveTasks.firstWhere(
                          (t) =>
                      t.room.target?.roomUuid == room.roomUuid &&
                          t.status == "pending",
                      orElse: () => EntityCleaningTask(
                        status: "",
                        type: "",
                      ),
                    );

                    final assigned = task.user.target != null;

                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child:ListTile( onTap: () async {
                      if (!assigned) {
                        Get.snackbar("Info", "No cleaning task assigned to this room.");
                        return;
                      }

                      final result = await Get.to(
                              () => ActivityBooking(),
                          arguments: {"mode": "cleaning", "room": room}
                      );

                      if (result == "done") {
                        controller.markDone(task);
                      }

                      if (result == "reassign") {
                        Get.dialog(DialogAssignCleaning());
                      }
                    },

                    ),
                    );
                  }).toList(),
                );
              }),

              const SizedBox(height: 40),

              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.cleaning_services),
                  label: const Text("Assign Cleaning Task"),
                  onPressed: () {
                    Get.dialog(DialogAssignCleaning());
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        title,
        style:
        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _staffCard(
      BuildContext context,
      HousekeepingController controller,
      EntityUser user,
      bool isBusy,
      ) {
    final tasks = controller.tasksFor(user);

    final userName = [
      user.first,
      user.middle,
      user.last,
    ].where((e) => e != null && e.trim().isNotEmpty).join(" ");

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          userName.isNotEmpty ? userName : (user.username ?? "Staff"),
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          isBusy ? "Busy in cleaning" : "Available",
          style: TextStyle(
            color: isBusy ? Colors.red : Colors.green,
          ),
        ),
        children: [
          if (isBusy)
            ...tasks.map((task) {
              final room = task.room.target;
              return ListTile(
                title: Text("Room ${room?.number ?? '-'}"),
                subtitle: Text(
                  "Cleaning type: ${task.type}\nStatus: ${task.status}",
                ),
                trailing: ElevatedButton(
                  onPressed: () => controller.markDone(task),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text("DONE"),
                ),
              );
            }),
        ],
      ),
    );
  }
}
