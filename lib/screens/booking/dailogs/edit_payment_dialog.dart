import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/entity_payment.dart';
import '../../../service/service_currency.dart';
import '../../../service/service_object_box.dart';
import '../controller_booking.dart';

void showEditPaymentDialog(EntityPayment payment) {
  final currencyService = Get.find<ServiceCurrency>();
  final bookingCtrl=Get.put(ControllerBooking(initialRoom: Get.arguments));
  final boxPayment = Get.find<ServiceObjectBox>()
      .store
      .box<EntityPayment>();
  final amtCtrl = TextEditingController(text: payment.amount.toString());
  final txnCtrl = TextEditingController(text: payment.transactionId);
  final RxString selectedMode = payment.paymentMode.obs;
  final List<String> paymentModes = [
    'Cash',
    'Credit Card',
    'Debit Card',
    'UPI',
    'Net Banking',
    'Wallet',
  ];

  Get.dialog(
    Material(
      type: MaterialType.transparency,
      child: AlertDialog(
        title: const Text("Edit Payment"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // PAYMENT MODE
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Payment Mode',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              value: selectedMode.value,
              items: paymentModes.map((mode) {
                return DropdownMenuItem(
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

            // AMOUNT
            TextField(
              controller: amtCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Amount (${currencyService.symbol})",
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              payment.paymentMode = selectedMode.value;
              payment.transactionId = txnCtrl.text;
              payment.amount = double.tryParse(amtCtrl.text) ?? 0;

              //  DATABASE SAVE (VERY IMPORTANT)
              boxPayment.put(payment);

              //  UI REFRESH
              bookingCtrl.rxListPayment.refresh();
              bookingCtrl.updateTotal();

              Get.back();
            },

            child: const Text("Save"),
          ),
        ],
      ),
    ),
  );
}
