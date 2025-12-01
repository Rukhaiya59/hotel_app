import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/entity_guest.dart';
import 'controller_split_bill.dart';
class ControllerSplitPercent extends GetxController {
  final double totalAmount;
  final List<EntityGuest> guests;

  ControllerSplitPercent({
    required this.totalAmount,
    required this.guests,
  });

  final Map<String, TextEditingController> percentCtrls = {};
  final Map<String, TextEditingController> txnCtrls = {};
  final Map<String, RxString> paymentModes = {};

  final Map<String, RxDouble> guestAmounts = {}; // ✅ RX AMOUNT PER GUEST

  @override
  void onInit() {
    super.onInit();

    for (var g in guests) {
      percentCtrls[g.guestUuid!] = TextEditingController();
      txnCtrls[g.guestUuid!] = TextEditingController();
      paymentModes[g.guestUuid!] = "Cash".obs;
      guestAmounts[g.guestUuid!] = 0.0.obs; // ✅
    }
  }
  void updatePercent(String guestUuid, String value) {
    final percent = double.tryParse(value) ?? 0;
    final amount = (totalAmount * percent) / 100.0;

    guestAmounts[guestUuid]!.value = amount;

    final parent = Get.find<ControllerSplitBill>();
    parent.setPercentResult(buildResult()); // ✅ AUTO PUSH
  }


  List<Map<String, dynamic>> buildResult() {
    final List<Map<String, dynamic>> results = [];

    for (var g in guests) {
      final amt = guestAmounts[g.guestUuid!]!.value;

      if (amt > 0) {
        final percent =
            double.tryParse(percentCtrls[g.guestUuid!]!.text) ?? 0;

        results.add({
          "guestUuid": g.guestUuid,
          "label": g.first,
          "percent": percent,
          "amount": amt,
          "paymentMode": paymentModes[g.guestUuid!]!.value,
          "transactionId": txnCtrls[g.guestUuid!]!.text,
          "type": "percent",
        });
      }
    }

    return results;
  }
}
