import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/entity_guest.dart';
import 'controller_split_bill.dart';

class ControllerSplitGuest extends GetxController {
  final double totalAmount;
  final List<EntityGuest> guests;

  ControllerSplitGuest({
    required this.totalAmount,
    required this.guests,
  });

  final Map<String, TextEditingController> amountCtrls = {};
  final Map<String, TextEditingController> txnCtrls = {};
  final Map<String, RxString> paymentModes = {};

  @override
  void onInit() {
    super.onInit();

    for (var g in guests) {
      amountCtrls[g.guestUuid!] = TextEditingController();
      txnCtrls[g.guestUuid!] = TextEditingController();
      paymentModes[g.guestUuid!] = "Cash".obs;
    }
  }

  @override
  void onClose() {
    for (var c in amountCtrls.values) {
      c.dispose();
    }
    for (var c in txnCtrls.values) {
      c.dispose();
    }
    super.onClose();
  }

  // ✅ Sirf parent ko notify karega, text yahan SET NAHI karega
  void updateAmount(String uuid, String value) {
    final parent = Get.find<ControllerSplitBill>();
    parent.setGuestResult(buildResult());
  }

  // ✅ Final Result Builder
  List<Map<String, dynamic>> buildResult() {
    final List<Map<String, dynamic>> results = [];

    amountCtrls.forEach((guestUuid, ctrl) {
      final double amount = double.tryParse(ctrl.text.trim()) ?? 0;

      if (amount > 0) {
        final guest =
        guests.firstWhere((g) => g.guestUuid == guestUuid);

        results.add({
          "guestUuid": guestUuid,
          "label": guest.first,
          "amount": amount,
          "paymentMode": paymentModes[guestUuid]!.value,
          "transactionId": txnCtrls[guestUuid]!.text,
          "type": "guest",
        });
      }
    });

    return results;
  }
}
