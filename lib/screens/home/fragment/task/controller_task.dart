import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../model/entity_task.dart';
import '../../../../objectbox.g.dart';
import '../../../../service/service_object_box.dart';

class ControllerTask extends GetxController {
  late Box<EntityTask> _boxTask;
  RxList<EntityTask> rxListTask = <EntityTask>[].obs;

  @override
  void onInit() {
    final ob = Get.find<ServiceObjectBox>();
    _boxTask = ob.box<EntityTask>();
    loadTasks();
    super.onInit();
  }

  void loadTasks() {
    rxListTask.value = _boxTask.getAll();
    debugPrint("Tasks loaded: ${rxListTask.length}");
  }
}
