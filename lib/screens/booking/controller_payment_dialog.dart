// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mongo_dart/mongo_dart.dart' as mongo;
// import '../../model/entity_payment.dart';
// import '../../repository/repo_get_storage.dart';
// import '../../util/static_method.dart';
// import 'package:hotel/service/service_currency.dart';
//
// class ControllerPaymentDialog extends GetxController {
//   Future<List<EntityPayment>> showPaymentDialog(
//       BuildContext context,
//       List<EntityPayment> payments,
//       ) async {
//
//     final txnCtrl = TextEditingController();
//     final amtCtrl = TextEditingController();
//
//     final RxString selectedMode = 'Cash'.obs;
//
//     final RepoGetStorage repoGetStorage = Get.find();
//     final currencyService = Get.find<ServiceCurrency>();//currency
//
//     final List<String> paymentModes = [
//       'Cash',
//       'Credit Card',
//       'Debit Card',
//       'UPI',
//       'Net Banking',
//       'Wallet',
//     ];
//
//     await Get.dialog(
//       Material(
//         type: MaterialType.transparency,
//         child: AlertDialog(
//           title: const Text("Payment Detail"),
//           content: Obx(() {
//             return Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // PAYMENT MODE DROPDOWN
//                 DropdownButtonFormField<String>(
//                   decoration: InputDecoration(
//                     labelText: 'Select Payment Mode',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   value: selectedMode.value,
//                   items: paymentModes.map((mode) {
//                     return DropdownMenuItem<String>(
//                       value: mode,
//                       child: Text(mode),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     if (value != null) selectedMode.value = value;
//                   },
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 // TRANSACTION ID
//                 TextField(
//                   controller: txnCtrl,
//                   decoration: const InputDecoration(
//                     labelText: "Transaction ID",
//                   ),
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 // AMOUNT WITH SELECTED CURRENCY SYMBOL
//                 TextField(
//                   controller: amtCtrl,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: "Amount (${currencyService.symbol})",//currency
//                     border: const OutlineInputBorder(),
//                   ),
//                 ),
//               ],
//             );
//           }),
//           actions: [
//             TextButton(
//               onPressed: () => Get.back(),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 payments.add(
//                   EntityPayment(
//                     paymentUuid: mongo.ObjectId().oid,
//                     amount: double.tryParse(amtCtrl.text) ?? 0,
//                     currency: currencyService.currency.value, // << correct//currency
//                     paymentMode: selectedMode.value,
//                     transactionId: txnCtrl.text,
//                     hotelUuid: repoGetStorage.getHotelUuid().toString(),
//                     createdAt: StaticMethod.getCurrentDateTimeToString(),
//                   ),
//                 );
//                 Get.back();
//               },
//               child: const Text("Save Payment"),
//             ),
//           ],
//         ),
//       ),
//     );
//
//     return payments;
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../../model/entity_payment.dart';
import '../../repository/repo_get_storage.dart';
import '../../util/static_method.dart';
import 'package:hotel/service/service_currency.dart';

class ControllerPaymentDialog extends GetxController {
  Future<List<EntityPayment>> showPaymentDialog(
      BuildContext context,
      List<EntityPayment> payments,
      ) async {
    final txnCtrl = TextEditingController();
    final amtCtrl = TextEditingController();

    final RxString selectedMode = 'Cash'.obs;

    final RepoGetStorage repoGetStorage = Get.find();
    final currencyService = Get.find<ServiceCurrency>();

    final List<String> paymentModes = [
      'Cash',
      'Credit Card',
      'Debit Card',
      'UPI',
      'Net Banking',
      'Wallet',
    ];

    await Get.dialog(
      Material(
        type: MaterialType.transparency,
        child: AlertDialog(
          title: const Text("Payment Detail"),
          content: Obx(() {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// PAYMENT MODE DROPDOWN
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Payment Mode',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: selectedMode.value,
                  items: paymentModes.map((mode) {
                    return DropdownMenuItem<String>(
                      value: mode,
                      child: Text(mode),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) selectedMode.value = value;
                  },
                ),

                const SizedBox(height: 10),

                /// TRANSACTION ID
                if (selectedMode.value != 'Cash')
                  TextField(
                    controller: txnCtrl,
                    decoration: const InputDecoration(
                      labelText: "Transaction ID",
                    ),
                  ),

                const SizedBox(height: 10),

                /// AMOUNT WITH CURRENCY
                TextField(
                  controller: amtCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Amount (${currencyService.symbol})",
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            );
          }),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                /// AMOUNT VALIDATION
                final double amount = double.tryParse(amtCtrl.text) ?? 0;
                if (amount <= 0) {
                  Get.snackbar("Invalid Amount", "Enter a valid payment amount",
                      backgroundColor: Colors.red.shade300,
                      colorText: Colors.white);
                  return;
                }

                /// TRANSACTION ID VALIDATION
                final mode = selectedMode.value;
                final txn = txnCtrl.text.trim();

                if (mode != "Cash") {
                  if (txn.isEmpty) {
                    Get.snackbar(
                      "Transaction ID Required",
                      "Please enter transaction ID",
                      backgroundColor: Colors.red.shade300,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  /// UPI VALIDATION
                  if (mode == "UPI") {
                    final upiRegex = RegExp(
                        r"^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$");
                    if (!upiRegex.hasMatch(txn)) {
                      Get.snackbar(
                        "Invalid UPI ID",
                        "Enter correct UPI ID (example: myname@oksbi)",
                        backgroundColor: Colors.red.shade300,
                        colorText: Colors.white,
                      );
                      return;
                    }
                  }

                  /// CARD VALIDATION (last 4–6 digits)
                  if (mode == "Credit Card" || mode == "Debit Card") {
                    final cardRegex = RegExp(r"^[0-9]{4,6}$");
                    if (!cardRegex.hasMatch(txn)) {
                      Get.snackbar(
                        "Invalid Card Reference",
                        "Enter last 4–6 digits only",
                        backgroundColor: Colors.red.shade300,
                        colorText: Colors.white,
                      );
                      return;
                    }
                  }

                  /// NET BANKING / BANK TRANSFER
                  if (mode == "Net Banking") {
                    final netRegex = RegExp(r"^[A-Z0-9]{8,20}$");
                    if (!netRegex.hasMatch(txn.toUpperCase())) {
                      Get.snackbar(
                        "Invalid Bank Transaction ID",
                        "Use 8–20 alphanumeric characters",
                        backgroundColor: Colors.red.shade300,
                        colorText: Colors.white,
                      );
                      return;
                    }
                  }

                  /// WALLET (Paytm, PhonePe etc.)
                  if (mode == "Wallet") {
                    final walletRegex =
                    RegExp(r"^[A-Za-z0-9]{6,20}$"); // simple reference
                    if (!walletRegex.hasMatch(txn)) {
                      Get.snackbar(
                        "Invalid Wallet Ref",
                        "Wallet Ref ID must be 6–20 characters",
                        backgroundColor: Colors.red.shade300,
                        colorText: Colors.white,
                      );
                      return;
                    }
                  }
                }

                /// IF VALIDATION SUCCESS → SAVE
                payments.add(
                  EntityPayment(
                    paymentUuid: mongo.ObjectId().oid,
                    amount: amount,
                    currency: currencyService.currency.value,
                    paymentMode: selectedMode.value,
                    transactionId: txn,
                    hotelUuid: repoGetStorage.getHotelUuid().toString(),
                    createdAt: StaticMethod.getCurrentDateTimeToString(),
                  ),
                );

                Get.back();
              },
              child: const Text("Save Payment"),
            ),
          ],
        ),
      ),
    );

    return payments;
  }
}
