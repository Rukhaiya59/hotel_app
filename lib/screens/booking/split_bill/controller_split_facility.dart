// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../model/entity_guest.dart';
// import '../../../model/entity_amenities.dart';
// import 'controller_split_bill.dart';
// class ControllerSplitFacility extends GetxController {
//   final double totalAmount;
//   final List<EntityGuest> guests;
//   final List<EntityAmenities> facilities;
//
//   ControllerSplitFacility({
//     required this.totalAmount,
//     required this.guests,
//     required this.facilities,
//   });
//
//   final Map<String, RxBool> selectedFacilities = {};
//   final Map<String, TextEditingController> txnCtrls = {};
//   final Map<String, RxString> paymentModes = {};
//
//   final RxDouble selectedFacilityTotal = 0.0.obs; // ✅ FIX
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     for (var f in facilities) {
//       selectedFacilities[f.name ?? ""] = true.obs;
//     }
//
//     for (var g in guests) {
//       txnCtrls[g.guestUuid!] = TextEditingController();
//       paymentModes[g.guestUuid!] = "Cash".obs;
//     }
//
//     _recalculateTotal(); // ✅ initial calc
//   }
//   void toggleFacility(String key, bool value) {
//     selectedFacilities[key]?.value = value;
//     _recalculateTotal();
//
//     final parent = Get.find<ControllerSplitBill>();
//     parent.setFacilityResult(buildResult()); // ✅ AUTO PUSH
//   }
//
//   void _recalculateTotal() {
//     double total = 0.0;
//     for (var f in facilities) {
//       if (selectedFacilities[f.name]?.value == true) {
//         total += (f.price ?? 0);
//       }
//     }
//     selectedFacilityTotal.value = total;
//   }
//
//   double get perGuestAmount {
//     if (guests.isEmpty) return 0;
//     return selectedFacilityTotal.value / guests.length;
//   }
//
//   List<Map<String, dynamic>> buildResult() {
//     final List<Map<String, dynamic>> results = [];
//
//     for (var g in guests) {
//       results.add({
//         "guestUuid": g.guestUuid,
//         "label": g.first,
//         "amount": perGuestAmount,
//         "paymentMode": paymentModes[g.guestUuid!]!.value,
//         "transactionId": txnCtrls[g.guestUuid!]!.text,
//         "type": "facility",
//       });
//     }
//
//     return results;
//   }
// }
