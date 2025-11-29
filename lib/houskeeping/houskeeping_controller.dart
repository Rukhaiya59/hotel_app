import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/entity_cleaning_task.dart';
import '../../model/entity_room.dart';
import '../../model/entity_user.dart';
import '../../model/entity_booking.dart';
import '../../service/service_object_box.dart';
import '../../objectbox.g.dart';
import '../../model/entity_cleaning_task.dart';

import '../../enums/enum_room_status.dart';
import '../../enums/enum_role.dart';
import '../../util/snackbar_util.dart';

class HousekeepingController extends GetxController {
  late Box<EntityUser> boxUser;
  late Box<EntityRoom> boxRoom;
  late Box<EntityBooking> boxBooking;
  late Box<EntityCleaningTask> boxTask;

  final rxStaff = <EntityUser>[].obs;
  final rxActiveTasks = <EntityCleaningTask>[].obs;
  final rxCleaningRooms = <EntityRoom>[].obs;

  @override
  void onInit() {
    super.onInit();

    final ob = Get.find<ServiceObjectBox>();

    boxUser = ob.box<EntityUser>();
    boxRoom = ob.box<EntityRoom>();
    boxBooking = ob.box<EntityBooking>();
    boxTask = ob.box<EntityCleaningTask>();

    refreshAll();
  }

  void refreshAll() {
    loadStaff();
    loadTasks();
    loadCleaningRooms();
  }
  void loadStaff() {
    final query = boxUser
        .query(EntityUser_.role.equals(EnumRole.housekeeping.value))
      ..order(EntityUser_.first);

    final rawList = query.build().find();

    // 🔥 Remove duplicates using userUuid (safe unique key)
    final unique = <String, EntityUser>{};

    for (var u in rawList) {
      final key = u.userUuid ?? "unknown_${u.id}";
      unique[key] = u;
    }

    // 🔥 Assign unique + sorted users
    rxStaff.assignAll(
      unique.values.toList()
        ..sort((a, b) =>
            (a.first ?? '').compareTo(b.first ?? '')),
    );
  }


  void loadTasks() {
    final query = boxTask
        .query(EntityCleaningTask_.status.equals("pending"))
      ..order(EntityCleaningTask_.createdAt, flags: Order.descending);

    rxActiveTasks.assignAll(query.build().find());
  }

  void loadCleaningRooms() {
    final rooms = boxRoom
        .query(EntityRoom_.status.equals(EnumRoomStatus.cleaning.name))
        .build()
        .find();

    final seen = <String>{};
    final uniqueRooms = <EntityRoom>[];

    for (var r in rooms) {
      final rid = r.roomUuid ?? "unknown_${r.roomId}";

      if (!seen.contains(rid)) {
        seen.add(rid);
        uniqueRooms.add(r);
      }
    }

    rxCleaningRooms.assignAll(uniqueRooms);
  }



  bool isBusy(EntityUser user) {
    return rxActiveTasks.any(
            (t) => t.user.target?.userUuid == user.userUuid);
  }

  List<EntityCleaningTask> tasksFor(EntityUser user) {
    return rxActiveTasks
        .where((t) => t.user.target?.userUuid == user.userUuid)
        .toList();
  }

  Future<void> assignTask({
    required EntityUser staff,
    required EntityRoom room,
    required String type,
  }) async {
    final task = EntityCleaningTask(
      status: "pending",
      type: type,
    );

    task.user.target = staff;
    task.room.target = room;

    boxTask.put(task);

    room.status = EnumRoomStatus.cleaning.name;
    boxRoom.put(room);

    SnackbarUtil.showSuccess(
        "Cleaning assigned to ${staff.first ?? staff.username}");

    refreshAll();
  }

  void markDone(EntityCleaningTask task) {
    final room = task.room.target;
    final booking = task.booking.target;

    task.status = "done";
    task.completedAt = DateTime.now();
    boxTask.put(task);

    if (task.type == "stayover") {
      SnackbarUtil.showSuccess("Stayover cleaning completed.");
      refreshAll();
      return;
    }

    if (room != null) {
      room.status = EnumRoomStatus.available.name;
      room.bookingUuid = null;
      boxRoom.put(room);
    }

    if (booking != null) {
      booking.room.target = null;
      boxBooking.put(booking);
    }

    SnackbarUtil.showSuccess("Room is now available");

    refreshAll();
  }
}
