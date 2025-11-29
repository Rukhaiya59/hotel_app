import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../model/entity_lost_found.dart';
import '../home/fragment/lost&found/controller_lost_and_found.dart';

class ControllerLostFoundCreate extends GetxController {
  final ControllerLostAndFound controllerLostFound = Get.find();

  final name = TextEditingController();
  final location = TextEditingController();
  final customerDetail = TextEditingController();
  final dateFound = DateTime.now().obs;
  final status = "unclaim".obs;

  Future<void> saveItem() async {
    final item = EntityFoundItem(
      name: name.text,
      location: location.text,
      customerDetail: customerDetail.text,
      dateFound: dateFound.value.toString(),
      status: status.value,
    );

    controllerLostFound.addFoundItem(item);
    Get.back();
  }
  Future <void> clearForm() async{
    name.dispose();
    location.dispose();
    customerDetail.dispose();
    dateFound.value = DateTime.now();
    status.value = "unclaim";
  }
}