// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../model/entity_user.dart';
// import '../../../../model/entity_room.dart';
// import '../../../../model/model_task.dart';
// import '../../../../util/snackbar_util.dart';
// import 'cleaning_controller.dart';
//
// class FragHomeCleaning extends StatelessWidget {
//   const FragHomeCleaning({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(CleaningController());
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Housekeeping"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               controller.loadHousekeepingUsers();
//               controller.loadPendingTasks();
//               controller.loadCleaningRooms();
//             },
//           ),
//         ],
//       ),
//       body: Obx(() {
//         final users = controller.housekeepingUsers;
//
//         if (users.isEmpty) {
//           return const Center(
//             child: Text(
//               "No housekeeping users found",
//               style: TextStyle(fontSize: 16),
//             ),
//           );
//         }
//
//         final available = users
//             .where((u) => !controller.isUserBusy(u))
//             .toList();
//         final busy = users
//             .where((u) => controller.isUserBusy(u))
//             .toList();
//
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // AVAILABLE STAFF
//               Text(
//                 "Available Staff",
//                 style: Theme.of(context)
//                     .textTheme
//                     .titleMedium
//                     ?.copyWith(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               if (available.isEmpty)
//                 const Padding(
//                   padding: EdgeInsets.only(bottom: 12.0),
//                   child: Text("No one is free right now."),
//                 )
//               else
//                 ...available.map(
//                       (u) => _buildUserTile(
//                     context,
//                     controller,
//                     u,
//                     isBusy: false,
//                   ),
//                 ),
//
//               const SizedBox(height: 20),
//
//               // BUSY STAFF
//               Text(
//                 "Busy Staff",
//                 style: Theme.of(context)
//                     .textTheme
//                     .titleMedium
//                     ?.copyWith(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               if (busy.isEmpty)
//                 const Text("No one is on a task.")
//               else
//                 ...busy.map(
//                       (u) => _buildUserTile(
//                     context,
//                     controller,
//                     u,
//                     isBusy: true,
//                   ),
//                 ),
//
//               const SizedBox(height: 24),
//             ],
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildUserTile(
//       BuildContext context,
//       CleaningController controller,
//       EntityUser user, {
//         required bool isBusy,
//       }) {
//     final tasks = controller.tasksForUser(user);
//
//     final displayName =
//     (user.first ?? user.username ?? user.employeeId ?? 'Unknown').trim();
//
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () => _openAssignDialog(
//           context,
//           controller,
//           preselectedUser: user,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // HEADER ROW
//               Row(
//                 children: [
//                   CircleAvatar(
//                     child: Text(
//                       displayName.isNotEmpty
//                           ? displayName[0].toUpperCase()
//                           : "?",
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Text(
//                       displayName,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   if (isBusy)
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.orange.shade50,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         "${tasks.length} task(s)",
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Colors.orange,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     )
//                   else
//                     TextButton(
//                       onPressed: () => _openAssignDialog(
//                         context,
//                         controller,
//                         preselectedUser: user,
//                       ),
//                       child: const Text("Assign Task"),
//                     ),
//                 ],
//               ),
//
//               const SizedBox(height: 8),
//
//               // STATUS TEXT
//               Text(
//                 isBusy
//                     ? "Currently working on cleaning tasks"
//                     : "Available for new task",
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: isBusy ? Colors.redAccent : Colors.green,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//
//               if (isBusy) const SizedBox(height: 8),
//
//               // TASK LIST FOR THIS USER
//               if (isBusy)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: tasks.map((t) {
//                     final room = t.room.target;
//                     final roomNumber = room?.number ?? "N/A";
//                     final typeLabel = _readableTaskType(t.taskType);
//
//                     return Container(
//                       margin: const EdgeInsets.only(top: 6),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade100,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment:
//                               CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Room: $roomNumber",
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 2),
//                                 Text(
//                                   typeLabel,
//                                   style: const TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.black54,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           ElevatedButton(
//                             onPressed: () =>
//                                 controller.markTaskDone(t),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                               shape: const StadiumBorder(),
//                             ),
//                             child: const Text(
//                               "Done",
//                               style: TextStyle(fontSize: 12),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _readableTaskType(String taskType) {
//     if (taskType == 'cleaning_checkout') return "Checkout Cleaning";
//     if (taskType == 'cleaning_stayover') return "Stayover Cleaning";
//     if (taskType == 'cleaning_manual') return "Manual Cleaning";
//     return taskType;
//   }
//
//   void _openAssignDialog(
//       BuildContext context,
//       CleaningController controller, {
//         EntityUser? preselectedUser,
//       }) {
//     final Rx<EntityUser?> selectedUser = (preselectedUser).obs;
//     final Rx<EntityRoom?> selectedRoom = Rx<EntityRoom?>(null);
//
//     // latest rooms load
//     controller.loadCleaningRooms();
//
//     Get.dialog(
//       AlertDialog(
//         title: const Text("Assign Cleaning Task"),
//         content: Obx(() {
//           final users = controller.housekeepingUsers;
//           final rooms = controller.cleaningRooms;
//
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               DropdownButtonFormField<EntityUser>(
//                 decoration: const InputDecoration(labelText: "Staff"),
//                 value: selectedUser.value,
//                 items: users
//                     .map(
//                       (u) => DropdownMenuItem<EntityUser>(
//                     value: u,
//                     child: Text(
//                       (u.first ?? u.username ?? u.employeeId ?? '')
//                           .trim()
//                           .isEmpty
//                           ? "Unknown"
//                           : (u.first ?? u.username ?? u.employeeId)!
//                           .trim(),
//                     ),
//                   ),
//                 )
//                     .toList(),
//                 onChanged: (val) => selectedUser.value = val,
//               ),
//               const SizedBox(height: 12),
//               DropdownButtonFormField<EntityRoom>(
//                 decoration: const InputDecoration(labelText: "Room"),
//                 value: selectedRoom.value,
//                 items: rooms
//                     .map(
//                       (r) => DropdownMenuItem<EntityRoom>(
//                     value: r,
//                     child: Text("Room ${r.number ?? ''}"),
//                   ),
//                 )
//                     .toList(),
//                 onChanged: (val) => selectedRoom.value = val,
//               ),
//               if (rooms.isEmpty)
//                 const Padding(
//                   padding: EdgeInsets.only(top: 8.0),
//                   child: Text(
//                     "No rooms in cleaning status.\n"
//                         "Checkout se cleaning task create hota hai.",
//                     style: TextStyle(fontSize: 11),
//                   ),
//                 ),
//             ],
//           );
//         }),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: const Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () async {
//               if (selectedUser.value == null ||
//                   selectedRoom.value == null) {
//                 SnackbarUtil.showError(
//                     "Please select staff and room");
//                 return;
//               }
//
//               await controller.assignCleaningTask(
//                 user: selectedUser.value!,
//                 room: selectedRoom.value!,
//               );
//               Get.back();
//             },
//             child: const Text("Assign"),
//           ),
//         ],
//       ),
//     );
//   }
// }
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
