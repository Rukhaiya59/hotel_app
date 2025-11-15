// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:objectbox/objectbox.dart';
//
// import '../../../../model/entity_inventory.dart';
// import '../../../../repository/repo_get_storage.dart';
// import '../../../../service/service_object_box.dart';
//
// class ControllerInventory extends GetxController {
//   late Box<EntityInventory> boxInventory;
//   RxList<EntityInventory> inventoryList = <EntityInventory>[].obs;
//   var searchQuery = "".obs;
//   String hotelUuid = "";
//   var filterType = "total".obs;
//   var showLowStock = false.obs; // toggle low stock/total
//   final RepoGetStorage _repoGetStorage = Get.find();
//
//   @override
//   void onInit() {
//     super.onInit();
//     hotelUuid = _repoGetStorage.getHotelUuid() ?? "";
//     boxInventory = Get.find<ServiceObjectBox>().box<EntityInventory>();
//     loadInventory();
//   }
//
//   void loadInventory() {
//     inventoryList.value = boxInventory
//         .getAll()
//         .where((e) => e.hotelUuid == hotelUuid)
//         .toList();
//   }
//
//   List<EntityInventory> get filteredInventory {
//     List<EntityInventory> list = showLowStock.value
//         ? inventoryList.where((e) => e.qty <= e.reorderLevel).toList()
//         : inventoryList;
//
//     if (searchQuery.value.isEmpty) return list;
//
//     return list
//         .where(
//           (e) =>
//               e.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
//               e.category.toLowerCase().contains(
//                 searchQuery.value.toLowerCase(),
//               ) ||
//               e.supplier.toLowerCase().contains(
//                 searchQuery.value.toLowerCase(),
//               ),
//         )
//         .toList();
//   }
//
//   void addInventory(EntityInventory item) {
//     item.hotelUuid = hotelUuid;
//     item.createdOn = DateTime.now().toString();
//     boxInventory.put(item);
//     loadInventory();
//   }
//
//   void editInventory(EntityInventory item) {
//     item.lastUpdatedOn = DateTime.now().toString();
//     boxInventory.put(item);
//     loadInventory();
//   }
//
//   void deleteInventory(int id) {
//     boxInventory.remove(id);
//     loadInventory();
//   }
//
//   void showAddDialog(BuildContext context) {
//     final name = TextEditingController();
//     final category = TextEditingController();
//     final qty = TextEditingController();
//     final unit = TextEditingController();
//     final price = TextEditingController();
//     final reorder = TextEditingController();
//     final supplier = TextEditingController();
//     final createdBy = TextEditingController();
//
//     Get.defaultDialog(
//       title: "Add Inventory Item",
//       content: SingleChildScrollView(
//         child: Column(
//           children: [
//             TextField(
//               controller: name,
//               decoration: InputDecoration(labelText: "Name"),
//             ),
//             TextField(
//               controller: category,
//               decoration: InputDecoration(labelText: "Category"),
//             ),
//             TextField(
//               controller: qty,
//               decoration: InputDecoration(labelText: "Qty"),
//               keyboardType: TextInputType.number,
//             ),
//             TextField(
//               controller: unit,
//               decoration: InputDecoration(labelText: "Unit"),
//             ),
//             TextField(
//               controller: price,
//               decoration: InputDecoration(labelText: "Price"),
//               keyboardType: TextInputType.number,
//             ),
//             TextField(
//               controller: reorder,
//               decoration: InputDecoration(labelText: "Reorder Level"),
//               keyboardType: TextInputType.number,
//             ),
//             TextField(
//               controller: supplier,
//               decoration: InputDecoration(labelText: "Supplier"),
//             ),
//             TextField(
//               controller: createdBy,
//               decoration: InputDecoration(labelText: "Created By"),
//             ),
//           ],
//         ),
//       ),
//       textConfirm: "Save",
//       textCancel: "Cancel",
//       onConfirm: () {
//         addInventory(
//           EntityInventory(
//             hotelUuid: hotelUuid,
//             name: name.text,
//             category: category.text,
//             qty: int.tryParse(qty.text) ?? 0,
//             unit: unit.text,
//             price: double.tryParse(price.text) ?? 0.0,
//             reorderLevel: int.tryParse(reorder.text) ?? 0,
//             supplier: supplier.text,
//             createdBy: createdBy.text,
//             createdOn: DateTime.now().toString(),
//           ),
//         );
//         Get.back();
//       },
//     );
//   }
//
//   void showEditDialog(BuildContext context, EntityInventory item) {
//     final name = TextEditingController(text: item.name);
//     final category = TextEditingController(text: item.category);
//     final qty = TextEditingController(text: item.qty.toString());
//     final unit = TextEditingController(text: item.unit);
//     final price = TextEditingController(text: item.price.toString());
//     final reorder = TextEditingController(text: item.reorderLevel.toString());
//     final supplier = TextEditingController(text: item.supplier);
//
//     Get.defaultDialog(
//       title: "Edit Inventory Item",
//       content: SingleChildScrollView(
//         child: Column(
//           children: [
//             TextField(
//               controller: name,
//               decoration: InputDecoration(labelText: "Name"),
//             ),
//             TextField(
//               controller: category,
//               decoration: InputDecoration(labelText: "Category"),
//             ),
//             TextField(
//               controller: qty,
//               decoration: InputDecoration(labelText: "Qty"),
//               keyboardType: TextInputType.number,
//             ),
//             TextField(
//               controller: unit,
//               decoration: InputDecoration(labelText: "Unit"),
//             ),
//             TextField(
//               controller: price,
//               decoration: InputDecoration(labelText: "Price"),
//               keyboardType: TextInputType.number,
//             ),
//             TextField(
//               controller: reorder,
//               decoration: InputDecoration(labelText: "Reorder Level"),
//               keyboardType: TextInputType.number,
//             ),
//             TextField(
//               controller: supplier,
//               decoration: InputDecoration(labelText: "Supplier"),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             deleteInventory(item.id);
//             Get.back();
//           },
//           child: Text("Delete", style: TextStyle(color: Colors.red)),
//         ),
//         TextButton(
//           onPressed: () {
//             item.name = name.text;
//             item.category = category.text;
//             item.qty = int.tryParse(qty.text) ?? item.qty;
//             item.unit = unit.text;
//             item.price = double.tryParse(price.text) ?? item.price;
//             item.reorderLevel = int.tryParse(reorder.text) ?? item.reorderLevel;
//             item.supplier = supplier.text;
//             editInventory(item);
//             Get.back();
//           },
//           child: Text("Update", style: TextStyle(color: Colors.blue)),
//         ),
//       ],
//     );
//   }
// }
import 'package:get/get.dart';
import 'package:objectbox/objectbox.dart';
import '../../../../model/entity_inventory.dart';
import '../../../../repository/repo_get_storage.dart';
import '../../../../service/service_object_box.dart';

class ControllerInventory extends GetxController {
  late Box<EntityInventory> boxInventory;
  RxList<EntityInventory> inventoryList = <EntityInventory>[].obs;
  var searchQuery = "".obs;
  String hotelUuid = "";
  var showLowStock = false.obs;
  final RepoGetStorage _repoGetStorage = Get.find();

  @override
  void onInit() {
    super.onInit();
    hotelUuid = _repoGetStorage.getHotelUuid() ?? "";
    boxInventory = Get.find<ServiceObjectBox>().box<EntityInventory>();
    loadInventory();
  }

  void loadInventory() {
    inventoryList.value =
        boxInventory.getAll().where((e) => e.hotelUuid == hotelUuid).toList();
  }

  List<EntityInventory> get filteredInventory {
    List<EntityInventory> list = showLowStock.value
        ? inventoryList.where((e) => e.qty <= e.reorderLevel).toList()
        : inventoryList;

    if (searchQuery.value.isEmpty) return list;

    return list
        .where(
          (e) =>
      e.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          e.category.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          e.supplier.toLowerCase().contains(searchQuery.value.toLowerCase()),
    )
        .toList();
  }

  void addInventory(EntityInventory item) {
    item.hotelUuid = hotelUuid;
    item.createdOn = DateTime.now().toString();
    boxInventory.put(item);
    loadInventory();
  }

  void editInventory(EntityInventory item) {
    item.lastUpdatedOn = DateTime.now().toString();
    boxInventory.put(item);
    loadInventory();
  }

  void deleteInventory(int id) {
    boxInventory.remove(id);
    loadInventory();
  }
}
