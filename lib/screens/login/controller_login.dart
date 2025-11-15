import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../commons/loader.dart';
import '../../model/entity_user.dart';
import '../../model/model_hotel.dart';
import '../../objectbox.g.dart';
import '../../repository/repo_get_storage.dart';
import '../../service/service_object_box.dart';
import '../../util/app_route.dart';
import '../../util/snackbar_util.dart';
import '../../util/static_method.dart';

class ControllerLogin extends GetxController {
  late Box<EntityUser> _boxUser;
  final RepoGetStorage _repoGetStorage = Get.find();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isPasswordHidden = true.obs;

  @override
  void onInit() {
    final ob = Get.find<ServiceObjectBox>();
    _boxUser = ob.box<EntityUser>();
    super.onInit();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void login() async {
    Loader.showLoader();

    await checkUserCount();

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      Loader.hideLoader();
      SnackbarUtil.showError('field_empty'.tr);
      return;
    }
    debugPrint('email: $email, password: $password');
    final query = _boxUser
        .query(
          EntityUser_.username.equals(email) &
              EntityUser_.password.equals(password),
        )
        .build();
    final user = query.findFirst();
    if (user == null) {
      Loader.hideLoader();
      SnackbarUtil.showError('invalid_credentials'.tr);
      return;
    }
    _repoGetStorage.setUser(json.encode(user.toMap()));
    Loader.hideLoader();
    Get.offAllNamed(AppRoute.home);
  }

  Future<void> checkUserCount() async {
    int userCount = _boxUser.count();
    debugPrint('userCount: $userCount');
    if (userCount == 0) {
      StaticMethod.loadUsersFromJson(_boxUser);
    } else {
      for (var user in _boxUser.getAll()) {
        debugPrint(json.encode(user.toMap()));
      }
    }
    debugPrint('strHotel: ${_repoGetStorage.getHotelJsonString()}');
    if (_repoGetStorage.getHotelJsonString() == null) {
      await loadHotelFromJson();
    }
  }

  Future<void> loadHotelFromJson() async {
    final String jsonString = await rootBundle.loadString(
      'assets/json/hotel.json',
    );
    debugPrint('jsonString: $jsonString');
    _repoGetStorage.setHotelJsonString(jsonString);
    final Map<String, dynamic> jsonHotel = json.decode(jsonString);
    final hotel = ModelHotel.fromJson(jsonHotel);
    _repoGetStorage.setHotelUuid(hotel.hotelUuid);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
