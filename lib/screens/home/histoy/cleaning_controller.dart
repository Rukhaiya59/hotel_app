// // import 'package:get/get.dart';
// // import 'package:hotel/model/entity_room.dart';
// // import 'package:hotel/model/entity_booking.dart';
// // import 'package:hotel/model/model_task.dart';
// // import 'package:hotel/objectbox.g.dart';
// // import 'package:hotel/service/service_object_box.dart';
// // import '../../../../enums/enum_room_status.dart';
// // import 'package:hotel/util/snackbar_util.dart';
// // class CleaningController extends GetxController {
// //   late Box<EntityTask> boxTask;
// //   late Box<EntityRoom> boxRoom;
// //   late Box<EntityBooking> boxBooking;
// //
// //   final RxList<EntityTask> pendingTasks = <EntityTask>[].obs;
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     final ob = Get.find<ServiceObjectBox>();
// //
// //     boxTask = ob.store.box<EntityTask>();
// //     boxRoom = ob.store.box<EntityRoom>();
// //     boxBooking = ob.store.box<EntityBooking>();
// //
// //     loadPendingTasks();
// //   }
// //
// //   //  Load only pending cleaning tasks
// //   void loadPendingTasks() {
// //     final tasks = boxTask
// //         .query(
// //         EntityTask_.status.equals("pending") &
// //         EntityTask_.taskType.contains("cleaning")
// //     )
// //         .build()
// //         .find();
// //
// //     pendingTasks.assignAll(tasks);
// //   }
// //
// //   //  Mark cleaning task done
// //   void markTaskDone(EntityTask task) {
// //     final room = task.room.target;
// //     final booking = task.booking.target;
// //
// //     // 1️ Update task status
// //     task.status = "done";
// //     boxTask.put(task);
// //
// //     // 2 Stayover cleaning
// //     if (task.taskType == "cleaning_stayover") {
// //       loadPendingTasks();
// //       SnackbarUtil.showSuccess("Stayover cleaning done");
// //       return;
// //     }
// //
// //     // 3️ Checkout cleaning (guest leaves)
// //     if (task.taskType == "cleaning_checkout") {
// //       if (room != null) {
// //         room.status = EnumRoomStatus.available.name;
// //         room.bookingUuid = null;
// //         boxRoom.put(room);
// //       }
// //
// //       if (booking != null) {
// //         booking.room.target = null;
// //         boxBooking.put(booking);
// //       }
// //
// //       SnackbarUtil.showSuccess(
// //           "Checkout cleaning completed. Room available now.");
// //     }
// //     loadPendingTasks();
// //   }
// // }
// import 'package:get/get.dart';
// import 'package:hotel/model/entity_room.dart';
// import 'package:hotel/model/entity_booking.dart';
// import 'package:hotel/model/model_task.dart';
// import 'package:hotel/model/entity_user.dart';
// import 'package:hotel/objectbox.g.dart';
// import 'package:hotel/service/service_object_box.dart';
// import '../../../../enums/enum_room_status.dart';
// import '../../../../enums/enum_role.dart';
// import 'package:hotel/util/snackbar_util.dart';
//
// class CleaningController extends GetxController {
//   late Box<EntityTask> boxTask;
//   late Box<EntityRoom> boxRoom;
//   late Box<EntityBooking> boxBooking;
//   late Box<EntityUser> boxUser;
//
//   /// Pending cleaning tasks (checkout + stayover)
//   final RxList<EntityTask> pendingTasks = <EntityTask>[].obs;
//
//   /// Sirf housekeeping users
//   final RxList<EntityUser> housekeepingUsers = <EntityUser>[].obs;
//
//   /// Saare rooms jinka status = cleaning
//   final RxList<EntityRoom> cleaningRooms = <EntityRoom>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     final ob = Get.find<ServiceObjectBox>();
//
//     boxTask = ob.box<EntityTask>();
//     boxRoom = ob.box<EntityRoom>();
//     boxBooking = ob.box<EntityBooking>();
//     boxUser = ob.box<EntityUser>();
//
//     loadHousekeepingUsers();
//     loadPendingTasks();
//     loadCleaningRooms();
//   }
//
//   /// Housekeeping users load karo (role = housekeeping)
//   void loadHousekeepingUsers() {
//     final qb = boxUser
//         .query(EntityUser_.role.equals(EnumRole.housekeeping.value))
//       ..order(EntityUser_.first);
//
//     final query = qb.build();
//     final list = query.find();
//     query.close();
//
//     housekeepingUsers.assignAll(list);
//   }
//
//   /// Sirf cleaning wale pending tasks
//   void loadPendingTasks() {
//     final qb = boxTask
//         .query(
//       EntityTask_.status.equals('pending') &
//       EntityTask_.taskType.contains('cleaning'),
//     )
//       ..order(EntityTask_.createdAt, flags: Order.descending);
//
//     final query = qb.build();
//     final list = query.find();
//     query.close();
//
//     pendingTasks.assignAll(list);
//   }
//
//   /// Rooms jinka status = cleaning
//   void loadCleaningRooms() {
//     final qb = boxRoom
//         .query(
//       EntityRoom_.status.equals(EnumRoomStatus.cleaning.name),
//     )
//       ..order(EntityRoom_.number);
//
//     final query = qb.build();
//     final list = query.find();
//     query.close();
//
//     cleaningRooms.assignAll(list);
//   }
//
//   /// Iss user ke saare pending cleaning tasks
//   List<EntityTask> tasksForUser(EntityUser user) {
//     return pendingTasks
//         .where((t) => t.assignedPerson == user.userUuid)
//         .toList();
//   }
//
//   bool isUserBusy(EntityUser user) => tasksForUser(user).isNotEmpty;
//
//   /// Kisi room ke liye existing pending cleaning task dhoondo
//   EntityTask? _findCleaningTaskForRoom(EntityRoom room) {
//     if (room.roomUuid == null) return null;
//
//     final qb = boxTask.query(
//       EntityTask_.status.equals('pending') &
//       EntityTask_.taskType.contains('cleaning'),
//     )..link(EntityTask_.room, EntityRoom_.roomUuid.equals(room.roomUuid!));
//
//     final query = qb.build();
//     final result = query.findFirst();
//     query.close();
//     return result;
//   }
//
//   /// Assign cleaning task user ko (existing task update karega)
//   Future<void> assignCleaningTask({
//     required EntityUser user,
//     required EntityRoom room,
//   }) async {
//     // 1 existing cleaning task dhoondo
//     EntityTask? task = _findCleaningTaskForRoom(room);
//
//     // Agar nahi mila toh ek manual cleaning task create kar do
//     task ??= EntityTask(taskType: 'cleaning_manual')
//       ..room.target = room;
//
//     task.assignedPerson = user.userUuid;
//     task.mobileNumber = user.mobile;
//
//     boxTask.put(task);
//
//     // room ka status ensure karo = cleaning
//     room.status = EnumRoomStatus.cleaning.name;
//     boxRoom.put(room);
//
//     loadPendingTasks();
//     loadCleaningRooms();
//
//     SnackbarUtil.showSuccess(
//       "Task assigned to ${user.first ?? user.username ?? ''}",
//     );
//   }
//
//   /// Task complete + room / booking update
//   void markTaskDone(EntityTask task) {
//     final room = task.room.target;
//     final booking = task.booking.target;
//
//     // 1 task complete
//     task.status = 'done';
//     task.completedAt = DateTime.now();
//     boxTask.put(task);
//
//     // 2 Stayover cleaning (room occupied rahega)
//     if (task.taskType == 'cleaning_stayover') {
//       SnackbarUtil.showSuccess("Stayover cleaning done");
//       loadPendingTasks();
//       loadCleaningRooms();
//       return;
//     }
//
//     // 3 Checkout cleaning / manual cleaning – room ko available kar do
//     if (room != null) {
//       room.status = EnumRoomStatus.available.name;
//       room.bookingUuid = null;
//       boxRoom.put(room);
//     }
//
//     if (booking != null) {
//       booking.room.target = null;
//       boxBooking.put(booking);
//     }
//
//     SnackbarUtil.showSuccess(
//       "Cleaning completed. Room available now.",
//     );
//
//     loadPendingTasks();
//     loadCleaningRooms();
//   }
// }

import 'package:get/get.dart';
import 'package:hotel/model/entity_cleaning_task.dart';
import 'package:hotel/model/entity_user.dart';
import 'package:hotel/model/entity_room.dart';
import 'package:hotel/objectbox.g.dart';
import 'package:hotel/service/service_object_box.dart';

class HousekeepingHistoryController extends GetxController {
  late Box<EntityCleaningTask> boxTask;
  late Box<EntityUser> boxUser;
  late Box<EntityRoom> boxRoom;

  final rxHistory = <EntityCleaningTask>[].obs;

  @override
  void onInit() {
    super.onInit();
    final ob = Get.find<ServiceObjectBox>();

    boxTask = ob.box<EntityCleaningTask>();
    boxUser = ob.box<EntityUser>();
    boxRoom = ob.box<EntityRoom>();

    loadHistory();
  }

  void loadHistory() {
    final qb = boxTask
        .query(EntityCleaningTask_.status.equals("done"))
      ..order(EntityCleaningTask_.completedAt, flags: Order.descending);

    final query = qb.build();      // Build query
    final list = query.find();     // Find items
    query.close();                 // CLOSE THE QUERY (not qb)

    rxHistory.assignAll(list);

  }
}
