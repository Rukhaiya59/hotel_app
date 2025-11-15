import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../model/entity_user.dart';
import '../../../../objectbox.g.dart';
import '../../../../service/service_object_box.dart';

class ControllerUser extends GetxController {
  var rxListUser = <EntityUser>[].obs;
  late Box<EntityUser> _boxUser;
  @override
  void onInit() {
    final ob = Get.find<ServiceObjectBox>();
    _boxUser = ob.box<EntityUser>();
    loadUsers();
    super.onInit();
  }

  Future<void> loadUsers() async {
    try {
      var list = _boxUser.getAll();
      rxListUser.value = list;
      debugPrint("Users loaded: ${list.length}");
    } catch (e) {
      debugPrint("Error loading users: $e");
    }
  }
}
