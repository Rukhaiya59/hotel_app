import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/model/model_icon_string.dart';
import 'package:hotel/repository/repo_constants.dart';
import 'package:hotel/util/app_route.dart';
import 'package:objectbox/objectbox.dart';
import '../../model/entity_user.dart';

import '../../repository/repo_get_storage.dart';
import '../../service/service_object_box.dart';

class ControllerHome extends GetxController {
  final RepoGetStorage _repoGetStorage = Get.find();
  late Box<EntityUser> boxUser;
  final Rx<EntityUser> rxUser = EntityUser(
    id: -1,
    userUuid: "",
    hotelUuid: "",
  ).obs;

  final RxList<ModelIconString> rxListDrawer = <ModelIconString>[].obs;
  final Rx<ModelIconString> rxSelectedDrawer = ModelIconString(
    icon: Icons.error_outline,
    title: "coming_soon".tr,
  ).obs;

  @override
  void onInit() {
    final ob = Get.find<ServiceObjectBox>();
    boxUser = ob.box<EntityUser>();
    getUserDetails();
    getDrawerMenu();
    debugPrint("hotelUuid: ${_repoGetStorage.getHotelUuid()}");
    super.onInit();
  }

  Future<void> getUserDetails() async {
    String strUser = _repoGetStorage.getUser() ?? "";
    debugPrint("getUserDetails: $strUser");
    var mapUser = json.decode(strUser);
    EntityUser entityUser = EntityUser.fromJson(mapUser);
    rxUser.value = entityUser;
  }

  Future<void> getDrawerMenu() async {
    var list = RepoConstants.getSampleListForRole(rxUser.value.role.toString());
    rxListDrawer.value = list;
  }

  Future<void> logout() async {
    _repoGetStorage.clearGetStorage();
    Get.offAllNamed(AppRoute.login);
  }
}
