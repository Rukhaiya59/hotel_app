import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:objectbox/objectbox.dart';
import 'package:hotel/model/entity_tax.dart';
import 'package:hotel/service/service_object_box.dart';

import '../../../../util/snackbar_util.dart';

class ControllerCreateTax extends GetxController {
  final EntityTax? editTax;

  ControllerCreateTax({this.editTax});

  late final Box<EntityTax> boxTax;

  // Text controllers
  final nameC = TextEditingController();
  final percentC = TextEditingController();

  // Switch states
  final isSgstCgst = false.obs;
  final isIncludeInRate = false.obs;
  final isPrintOnBill = true.obs;
  final isActive = true.obs;

  @override
  void onInit() {
    super.onInit();

    // ⭐ Correct way to access the initialized ObjectBox service
    boxTax = Get.find<ServiceObjectBox>().box<EntityTax>();

    // Load existing tax if editing
    if (editTax != null) {
      nameC.text = editTax!.taxProductName ?? "";
      percentC.text = (editTax!.taxPercentage ?? 0).toString();
      isSgstCgst.value = editTax!.isSgstCgst ?? false;
      isIncludeInRate.value = editTax!.isIncludeInRate ?? false;
      isPrintOnBill.value = editTax!.isPrintOnBill ?? true;
      isActive.value = editTax!.isActive ?? true;
    }
  }

  // Save or update tax
  void save() {
    final name = nameC.text.trim();
    final percent = double.tryParse(percentC.text.trim());

    if (name.isEmpty) {
      return SnackbarUtil.showError("Tax name is required");
    }

    if (percent == null || percent < 0) {
      return SnackbarUtil.showError("Invalid percentage");
    }

    if (editTax == null) {
      // CREATE NEW TAX
      final newTax = EntityTax(
        taxProductName: name,
        taxPercentage: percent,
        isSgstCgst: isSgstCgst.value,
        isIncludeInRate: isIncludeInRate.value,
        isPrintOnBill: isPrintOnBill.value,
        isActive: isActive.value,
      );

      boxTax.put(newTax);
      SnackbarUtil.showSuccess("Tax created successfully");
    } else {
      // UPDATE EXISTING TAX
      editTax!.taxProductName = name;
      editTax!.taxPercentage = percent;
      editTax!.isSgstCgst = isSgstCgst.value;
      editTax!.isIncludeInRate = isIncludeInRate.value;
      editTax!.isPrintOnBill = isPrintOnBill.value;
      editTax!.isActive = isActive.value;

      boxTax.put(editTax!);
      SnackbarUtil.showSuccess("Tax updated successfully");
    }

    Get.back(); // Close screen
  }
}
