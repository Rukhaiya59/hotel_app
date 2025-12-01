import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hotel/model/entity_booking.dart';
import 'package:hotel/service/service_object_box.dart';
import 'package:hotel/objectbox.g.dart';

import '../model/entity_cleaning_task.dart';
import '../model/model_task.dart';

class ServiceBookingScheduler extends GetxService {
  late Timer _timer;

  late Box<EntityBooking> boxBooking;
  // late Box<EntityTask> boxTask;
  late Box<EntityCleaningTask> boxTask;


  @override
  void onInit() {
    super.onInit();

    final ob = Get.find<ServiceObjectBox>();
    boxBooking = ob.store.box<EntityBooking>();
    // boxTask = ob.store.box<EntityTask>();
    boxTask = ob.store.box<EntityCleaningTask>();


    final duration = kDebugMode
        ? const Duration(minutes: 1)
        : const Duration(hours: 6);
    _timer = Timer.periodic(duration, (_) => checkScheduledTasks());
  }

  void checkScheduledTasks() {
    final now = DateTime.now();

    final nowIso = DateTime.now().toIso8601String();

    final list = boxBooking
        .query(
      EntityBooking_.cleaningTaskCreated.equals(false) &
      EntityBooking_.cleaningTime.lessOrEqual(nowIso),
    )
        .build()
        .find();

    for (var booking in list) {
      _createCleaningTask(booking);
    }
  }

  void _createCleaningTask(EntityBooking booking) {
    final room = booking.room.target;
    if (room == null) return;
    final task = EntityCleaningTask(
      status: "pending",
      type: "stayover",          // ✅ VERY IMPORTANT
      createdAt: DateTime.now().toIso8601String(),
    );


    task.room.target = room;
    task.booking.target = booking;
    boxTask.put(task);

    // mark created
    booking.cleaningTaskCreated = true;
    boxBooking.put(booking);
  }
}
