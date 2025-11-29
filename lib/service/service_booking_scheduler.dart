import 'dart:async';
import 'package:get/get.dart';
import 'package:hotel/model/entity_booking.dart';
import 'package:hotel/service/service_object_box.dart';
import 'package:hotel/objectbox.g.dart';

import '../model/model_task.dart';

class ServiceBookingScheduler extends GetxService {
  late Timer _timer;

  late Box<EntityBooking> boxBooking;
  late Box<EntityTask> boxTask;

  @override
  void onInit() {
    super.onInit();

    final ob = Get.find<ServiceObjectBox>();
    boxBooking = ob.store.box<EntityBooking>();
    boxTask = ob.store.box<EntityTask>();

    // Runs every 1 minute
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      checkScheduledTasks();
    });
  }

  void checkScheduledTasks() {
    final now = DateTime.now();

    final list = boxBooking
        .query(
        EntityBooking_.cleaningTaskCreated.equals(false) &
        EntityBooking_.cleaningTime.lessOrEqual(
          now.millisecondsSinceEpoch as String,
        )
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

    final task = EntityTask(
      taskType: "cleaning_scheduled",
      status: "pending",
      reason: "Scheduled cleaning",
      createdAt: DateTime.now.toString(),
    );

    task.room.target = room;
    task.booking.target = booking;
    boxTask.put(task);

    // mark created
    booking.cleaningTaskCreated = true;
    boxBooking.put(booking);
  }
}
