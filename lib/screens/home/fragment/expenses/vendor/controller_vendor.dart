import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/model/expense_category.dart';
import 'package:hotel/service/service_vendor.dart';
import 'package:hotel/util/snackbar_util.dart';
import '../../../../../model/entity_vendor.dart';
import '../../../../../service/service_object_box.dart';
import '../controller_expense.dart';
class VendorController extends GetxController {
  late VendorService service;
  var vendorList = <Vendor>[].obs;
  var loading = false.obs;
  // FORM Fields
  final name = TextEditingController();
  final category = TextEditingController();
  final phone = TextEditingController();
  final company = TextEditingController();

  @override
  void onInit() {
    final obx = Get.find<ServiceObjectBox>();
    service = VendorService(obx);
    loadVendors();   // <-- NOW THIS WORKS
    super.onInit();
  }

  // LOAD VENDORS  (THIS WAS MISSING!)
  void loadVendors() {
    loading(true);
    vendorList.value = service.getVendors();
    loading(false);
  }

  // ADD VENDOR + ADD CATEGORY
  void addVendor() {
    if (name.text.trim().isEmpty) {
      SnackbarUtil.showError("Error" "Vendor name is required");
      return;
    }

    final categoryName = category.text.trim();

    Vendor vendor = Vendor(
      name: name.text.trim(),
      categoryName: categoryName.isEmpty ? null : categoryName,
      phone: phone.text.trim().isEmpty ? null : phone.text.trim(),
      companyName: company.text.trim().isEmpty ? null : company.text.trim(),
    );

    // Save vendor
    service.addVendor(vendor);

    // SAVE CATEGORY ONLY IF NOT EXISTS
    if (categoryName.isNotEmpty) {
      final exists = Get.find<ControllerExpense>()
          .categories
          .any((e) => e.name.toLowerCase() == categoryName.toLowerCase());

      if (!exists) {
        Get.find<ControllerExpense>().service.addCategory(
          ExpenseCategory(name: categoryName),
        );
      }

      Get.find<ControllerExpense>().loadAll();
    }

    clearForm();
    loadVendors();
    SnackbarUtil.showSuccess("Vendor added successfully");
  }

  // DELETE
  void deleteVendor(int id) {
    service.deleteVendor(id);
    loadVendors();
  }
  // CLEAR FORM
  void clearForm() {
    name.clear();
    category.clear();
    phone.clear();
    company.clear();
  }
}
