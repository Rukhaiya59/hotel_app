import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/entity_amenities.dart';
import '../../../service/service_currency.dart';
import '../controller_booking.dart';

void showEditSelectedAmenityDialog(EntityAmenities amenity) {
  final nameCtrl = TextEditingController(text: amenity.name);
  final priceCtrl = TextEditingController(text: amenity.price?.toString());
  final qtyCtrl = TextEditingController(text: amenity.qty?.toString());
  final descCtrl = TextEditingController(text: amenity.description);

  final currencyService = Get.find<ServiceCurrency>();
  final bookingCtrl=Get.put(ControllerBooking(initialRoom: Get.arguments));

  Get.dialog(
    Material(
      type: MaterialType.transparency,
      child: AlertDialog(
        title: const Text("Edit Amenity"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Amenity Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText:
                "Price (${currencyService.symbol})",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: qtyCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Quantity"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: "Description"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              amenity.name = nameCtrl.text.trim();
              amenity.price = double.tryParse(priceCtrl.text) ?? 0;
              amenity.qty = int.tryParse(qtyCtrl.text) ?? 1;
              amenity.description = descCtrl.text.trim();

              // refresh UI
              bookingCtrl.rxListAmenities.refresh();   // ✅ UI Refresh
              bookingCtrl.updateTotal();               // ✅ Total Update

              Get.back();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    ),
  );
}
