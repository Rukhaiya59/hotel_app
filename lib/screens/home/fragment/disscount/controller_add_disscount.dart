import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../model/entity_discount.dart';
import 'controller_discount.dart';

class ControllerAddDiscount extends GetxController {

  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final valueCtrl = TextEditingController();
  final couponCtrl = TextEditingController();

  final discountType = "percentage".obs;
  final roomType = RxnString();
  final guestType = RxnString();

  final floor = RxnInt();
  final roomUuid = RxnString();
  final hotelUuid = RxnString();

  final fromDate = "".obs;
  final toDate = "".obs;

  EntityDiscount? editingDiscount; // ✅ IMPORTANT

  /// ✅ PREFILL FUNCTION
  void setEditData(EntityDiscount d) {
    editingDiscount = d;

    titleCtrl.text = d.title;
    descCtrl.text = d.description;
    valueCtrl.text = d.value.toString();
    couponCtrl.text = d.couponCode ?? "";

    discountType.value = d.discountType;
    roomType.value = d.roomType;
    guestType.value = d.guestType;

    fromDate.value = d.fromDate;
    toDate.value = d.toDate;
  }

  Future<void> pickDateRange(BuildContext context) async {
    final DateTimeRange? range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
      initialDateRange: fromDate.value.isNotEmpty
          ? DateTimeRange(
        start: DateTime.parse(fromDate.value),
        end: DateTime.parse(toDate.value),
      )
          : null,
    );

    if (range != null) {
      fromDate.value = range.start.toIso8601String().substring(0, 10);
      toDate.value = range.end.toIso8601String().substring(0, 10);
    }
  }

  /// ✅ SAVE OR UPDATE (AUTO SWITCH)
  void saveOrUpdateDiscount() {
    if (titleCtrl.text.isEmpty || valueCtrl.text.isEmpty) return;

    final discount = EntityDiscount(
      discountId: editingDiscount?.discountId ?? 0, // ✅ CRUCIAL
      title: titleCtrl.text,
      description: descCtrl.text,
      discountType: discountType.value,
      value: double.tryParse(valueCtrl.text) ?? 0,
      couponCode: couponCtrl.text.isEmpty ? null : couponCtrl.text,
      roomType: roomType.value,
      floor: floor.value,
      roomUuid: roomUuid.value,
      hotelUuid: hotelUuid.value,
      guestType: guestType.value,
      fromDate: fromDate.value,
      toDate: toDate.value,
    );

    if (editingDiscount == null) {
      Get.find<DiscountController>().addDiscount(discount);
      Get.snackbar("Saved", "Discount Added");
    } else {
      Get.find<DiscountController>().updateDiscount(discount);
      Get.snackbar("Updated", "Discount Updated");
    }

    clearForm();
  }

  void clearForm() {
    titleCtrl.clear();
    descCtrl.clear();
    valueCtrl.clear();
    couponCtrl.clear();

    fromDate.value = "";
    toDate.value = "";

    roomType.value = null;
    guestType.value = null;
    floor.value = null;
    roomUuid.value = null;
    hotelUuid.value = null;

    discountType.value = "percentage";
    editingDiscount = null;
  }
}
