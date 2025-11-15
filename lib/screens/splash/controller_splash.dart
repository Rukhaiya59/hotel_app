import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../repository/repo_get_storage.dart';
import '../../util/app_route.dart';

class ControllerSplash extends GetxController {
  final RepoGetStorage _repoGetStorage = Get.find();

  @override
  void onReady() {
    redirectToHomeScreen();
    super.onReady();
  }

  void redirectToHomeScreen() {
    debugPrint("redirectToHomeScreen++");
    Future.delayed(Duration(seconds: 1), () {
      debugPrint("redirectToHomeScreen 3sec");
      isUserLogin();
    });
    debugPrint("redirectToHomeScreen--");
  }

  void isUserLogin() {
    String? strUser = _repoGetStorage.getUser();
    debugPrint("splash strUser: $strUser");
    if (strUser == null) {
      Get.offAllNamed(AppRoute.login);
      return;
    }
    Get.offAllNamed(AppRoute.home);
  }
}
