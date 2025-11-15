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
    final currencyService = Get.find<ServiceCurrency>();//currency

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
                // PAYMENT MODE DROPDOWN
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

                // TRANSACTION ID
                TextField(
                  controller: txnCtrl,
                  decoration: const InputDecoration(
                    labelText: "Transaction ID",
                  ),
                ),

                const SizedBox(height: 10),

                // AMOUNT WITH SELECTED CURRENCY SYMBOL
                TextField(
                  controller: amtCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Amount (${currencyService.symbol})",//currency
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
                payments.add(
                  EntityPayment(
                    paymentUuid: mongo.ObjectId().oid,
                    amount: double.tryParse(amtCtrl.text) ?? 0,
                    currency: currencyService.currency.value, // << correct//currency
                    paymentMode: selectedMode.value,
                    transactionId: txnCtrl.text,
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