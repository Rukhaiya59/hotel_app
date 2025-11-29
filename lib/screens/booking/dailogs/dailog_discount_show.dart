import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/entity_discount.dart';
import '../controller_booking.dart';

class DiscountSelectDialog {
  static void show(BuildContext context) {
    final ControllerBooking controller = Get.find<ControllerBooking>();

    controller.selectedDiscount.value ??=
    controller.activeDiscounts.isNotEmpty
        ? controller.activeDiscounts.first
        : null;

    Get.dialog(
      AlertDialog(
        title: const Text("Apply Discount"),
        content: Obx(() {
          if (controller.activeDiscounts.isEmpty) {
            return const Text("No discounts available");
          }

          return DropdownButtonFormField<EntityDiscount>(
            value: controller.selectedDiscount.value,
            isExpanded: true,
            hint: const Text("Select Discount"),
            items: controller.activeDiscounts.map((d) {
              return DropdownMenuItem(
                value: d,
                child: Text(
                  "${d.title} (${d.discountType == 'percentage'
                      ? '${d.value}%'
                      : '₹${d.value}'})",
                ),
              );
            }).toList(),
            onChanged: (val) {
              controller.selectedDiscount.value = val;
            },
          );
        }),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.selectedDiscount.value != null) {
                controller.tecDiscountPrice.text =
                    controller.calculateDiscount(controller.roomRate)
                        .toStringAsFixed(2);

                controller.tecDiscountDescription.text =
                    controller.selectedDiscount.value!.title;

                controller.updateTotal();
              }

              Get.back();
            },
            child: const Text("Apply"),
          ),
        ],
      ),
    );
  }
}
