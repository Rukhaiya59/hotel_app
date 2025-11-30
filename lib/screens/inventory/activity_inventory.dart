import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/util/snackbar_util.dart';
import '../../model/entity_vendor.dart';
import '../home/fragment/expenses/vendor/controller_vendor.dart';
import '../home/fragment/inventory/controller_inventory.dart';
import '../../../../model/entity_inventory.dart';

class InventoryForm {
  static void showAddForm(BuildContext context, ControllerInventory controller) {
    final qty = TextEditingController();
    final unit = TextEditingController();
    final price = TextEditingController();
    final reorder = TextEditingController();
    final supplier = TextEditingController();
    final createdBy = TextEditingController();

    final VendorController vendorCtrl = Get.find<VendorController>();
    final selectedVendor = Rx<Vendor?>(null);
    final category = TextEditingController();

    Get.defaultDialog(
      title: "Add Inventory Item",
      content: SingleChildScrollView(
        child: Column(
          children: [

            /// ✅ Vendor Dropdown
            Obx(() {
              return DropdownButtonFormField<Vendor>(
                value: selectedVendor.value,
                decoration: const InputDecoration(labelText: "Select Vendor"),
                items: vendorCtrl.vendorList
                    .map((v) => DropdownMenuItem(
                  value: v,
                  child: Text(v.name),
                ))
                    .toList(),
                onChanged: (v) {
                  selectedVendor.value = v;

                  // ✅ Auto Category
                  category.text = v?.categoryName ?? "";

                  // ✅ Auto Price (if available)
                  if (v?.defaultPrice != null) {
                    price.text = v!.defaultPrice.toString();
                  }
                },
              );
            }),

            TextField(
              controller: category,
              decoration: const InputDecoration(labelText: "Category"),
              readOnly: true,
            ),

            TextField(
              controller: qty,
              decoration: const InputDecoration(labelText: "Qty"),
              keyboardType: TextInputType.number,
            ),

            TextField(
              controller: unit,
              decoration: const InputDecoration(labelText: "Unit"),
            ),

            TextField(
              controller: price,
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
            ),

            TextField(
              controller: reorder,
              decoration: const InputDecoration(labelText: "Reorder Level"),
              keyboardType: TextInputType.number,
            ),

            TextField(
              controller: supplier,
              decoration: const InputDecoration(labelText: "Supplier"),
            ),

            TextField(
              controller: createdBy,
              decoration: const InputDecoration(labelText: "Created By"),
            ),
          ],
        ),
      ),

      textConfirm: "Save",
      textCancel: "Cancel",

      onConfirm: () {
        if (selectedVendor.value == null) {
          SnackbarUtil.showError("Error" "Please select vendor");
          return;
        }

        final item = EntityInventory(
          hotelUuid: controller.hotelUuid,
          name: selectedVendor.value!.name,       // ✅ From Vendor
          category: category.text,               // ✅ From Vendor
          qty: int.tryParse(qty.text) ?? 0,
          unit: unit.text,
          price: double.tryParse(price.text) ?? 0,
          reorderLevel: int.tryParse(reorder.text) ?? 0,
          supplier: supplier.text,
          createdBy: createdBy.text,
          createdOn: DateTime.now().toString(),
        );

        // ✅ SAVE VENDOR RELATION
        item.vendor.target = selectedVendor.value;

        controller.addInventory(item);
        Get.back();
      },
    );
  }


  static void showEditForm(BuildContext context, ControllerInventory controller, EntityInventory item) {
    final name = TextEditingController(text: item.name);
    final category = TextEditingController(text: item.category);
    final qty = TextEditingController(text: item.qty.toString());
    final unit = TextEditingController(text: item.unit);
    final price = TextEditingController(text: item.price.toString());
    final reorder = TextEditingController(text: item.reorderLevel.toString());
    final supplier = TextEditingController(text: item.supplier);

    Get.defaultDialog(
      title: "Edit Inventory Item",
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(controller: name, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: category, decoration: InputDecoration(labelText: "Category")),
            TextField(controller: qty, decoration: InputDecoration(labelText: "Qty"), keyboardType: TextInputType.number),
            TextField(controller: unit, decoration: InputDecoration(labelText: "Unit")),
            TextField(controller: price, decoration: InputDecoration(labelText: "Price"), keyboardType: TextInputType.number),
            TextField(controller: reorder, decoration: InputDecoration(labelText: "Reorder Level"), keyboardType: TextInputType.number),
            TextField(controller: supplier, decoration: InputDecoration(labelText: "Supplier")),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            controller.deleteInventory(item.id);
            Get.back();
          },
          child: Text("Delete", style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () {
            item.name = name.text;
            item.category = category.text;
            item.qty = int.tryParse(qty.text) ?? item.qty;
            item.unit = unit.text;
            item.price = double.tryParse(price.text) ?? item.price;
            item.reorderLevel = int.tryParse(reorder.text) ?? item.reorderLevel;
            item.supplier = supplier.text;
            controller.editInventory(item);
            Get.back();
          },
          child: Text("Update", style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }
}