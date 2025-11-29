import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> showDeleteConfirmation({
  required String title,
  String? message,
}) async {
  bool confirmed = false;

  await Get.defaultDialog(
    title: "Delete",
    titleStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    middleText: message ?? "Do you want to delete $title?",
    middleTextStyle: const TextStyle(fontSize: 16),
    textCancel: "Cancel",
    textConfirm: "Delete",
    confirmTextColor: Colors.white,
    buttonColor: Colors.red,
    onConfirm: () {
      confirmed = true;
      Get.back();
    },
    onCancel: () {
      confirmed = false;
    },
  );

  return confirmed;
}
