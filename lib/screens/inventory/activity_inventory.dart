import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home/fragment/inventory/controller_inventory.dart';
import '../../../../model/entity_inventory.dart';

class InventoryForm {
  static void showAddForm(BuildContext context, ControllerInventory controller) {
    final name = TextEditingController();
    final category = TextEditingController();
    final qty = TextEditingController();
    final unit = TextEditingController();
    final price = TextEditingController();
    final reorder = TextEditingController();
    final supplier = TextEditingController();
    final createdBy = TextEditingController();

    Get.defaultDialog(
      title: "Add Inventory Item",
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
            TextField(controller: createdBy, decoration: InputDecoration(labelText: "Created By")),
          ],
        ),
      ),
      textConfirm: "Save",
      textCancel: "Cancel",
      onConfirm: () {
        controller.addInventory(EntityInventory(
          hotelUuid: controller.hotelUuid,
          name: name.text,
          category: category.text,
          qty: int.tryParse(qty.text) ?? 0,
          unit: unit.text,
          price: double.tryParse(price.text) ?? 0,
          reorderLevel: int.tryParse(reorder.text) ?? 0,
          supplier: supplier.text,
          createdBy: createdBy.text,
          createdOn: DateTime.now().toString(),
        ));
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
