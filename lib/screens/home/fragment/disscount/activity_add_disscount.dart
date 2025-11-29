import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../model/entity_discount.dart';
import 'controller_add_disscount.dart';

class ActivityAddDiscount extends StatelessWidget {
  final EntityDiscount? editDiscount;

  const ActivityAddDiscount({super.key, this.editDiscount});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ControllerAddDiscount());

    if (editDiscount != null) {
      controller.setEditData(editDiscount!);
    }

    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        editDiscount == null ? "Add Discount" : "Edit Discount",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),

      content: SingleChildScrollView(
        child: Column(
          children: [

            _field("Title", controller.titleCtrl),
            _field("Description", controller.descCtrl),
            _field("Value", controller.valueCtrl,
                type: TextInputType.number),
            _field("Coupon Code", controller.couponCtrl),

            const SizedBox(height: 10),

            Obx(() => DropdownButtonFormField(
              value: controller.discountType.value,
              decoration: _dropdownDecoration("Discount Type"),
              items: const [
                DropdownMenuItem(value: "percentage", child: Text("Percentage")),
                DropdownMenuItem(value: "fixed", child: Text("Fixed")),
              ],
              onChanged: (v) => controller.discountType.value = v!,
            )),

            const SizedBox(height: 10),

            Obx(() => DropdownButtonFormField(
              value: controller.roomType.value,
              decoration: _dropdownDecoration("Room Type"),
              items: const [
                DropdownMenuItem(value: "Deluxe", child: Text("Deluxe")),
                DropdownMenuItem(value: "Standard", child: Text("Standard")),
                DropdownMenuItem(value: "Suite", child: Text("Suite")),
              ],
              onChanged: (v) => controller.roomType.value = v,
            )),

            const SizedBox(height: 10),

            Obx(() => DropdownButtonFormField(
              value: controller.guestType.value,
              decoration: _dropdownDecoration("Guest Type"),
              items: const [
                DropdownMenuItem(value: "Adult", child: Text("Adult")),
                DropdownMenuItem(value: "Child", child: Text("Child")),
                DropdownMenuItem(value: "Corporate", child: Text("Corporate")),
                DropdownMenuItem(value: "VIP", child: Text("VIP")),
              ],
              onChanged: (v) => controller.guestType.value = v,
            )),

            const SizedBox(height: 16),

            /// DATE BUTTON (THEME STYLE)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => controller.pickDateRange(context),
                icon: const Icon(Icons.date_range),
                label: const Text("Select Discount Date Range"),
              ),
            ),

            const SizedBox(height: 6),

            Obx(() {
              if (controller.fromDate.value.isEmpty) return const SizedBox();
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "From: ${controller.fromDate.value}  →  ${controller.toDate.value}",
                  style: const TextStyle(fontSize: 12),
                ),
              );
            }),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            controller.clearForm();
            Get.back();
          },
          child: const Text("Cancel"),
        ),

        ElevatedButton(
          onPressed: () {
            controller.saveOrUpdateDiscount();
            Get.back();
          },
          child: Text(editDiscount == null ? "Save" : "Update"),
        ),
      ],
    );
  }

  Widget _field(String label, TextEditingController ctrl,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        keyboardType: type,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(labelText: label);
  }
}
