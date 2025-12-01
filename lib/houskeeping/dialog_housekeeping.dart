import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/entity_user.dart';
import '../../model/entity_room.dart';
import '../enums/enum_cleaning_type.dart';
import 'houskeeping_controller.dart';

class DialogAssignCleaning extends StatelessWidget {
  DialogAssignCleaning({super.key});

  final controller = Get.find<HousekeepingController>();

  @override
  Widget build(BuildContext context) {
    final selectedStaff = Rxn<EntityUser>();
    final selectedRoom = Rxn<EntityRoom>();
    final selectedType = CleaningType.checkout.obs;


    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        "Assign Cleaning Task",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),

      content: Obx(() {
        return SizedBox(
          width: 330,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // STAFF
                DropdownButtonFormField<String>(
                  value: selectedStaff.value?.userUuid,
                  decoration: const InputDecoration(
                    labelText: "Select Staff",
                    border: OutlineInputBorder(),
                  ),
                  items: controller.rxStaff.map((u) {
                    final name = "${u.first ?? ''} ${u.last ?? ''}".trim();
                    return DropdownMenuItem(
                      value: u.userUuid,     // STRING VALUE
                      child: Text(name.isNotEmpty ? name : (u.username ?? "Staff")),
                    );
                  }).toList(),
                  onChanged: (val) {
                    selectedStaff.value =
                        controller.rxStaff.firstWhere((u) => u.userUuid == val);
                  },
                ),

                const SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  value: selectedRoom.value?.roomUuid,
                  decoration: const InputDecoration(
                    labelText: "Select Room",
                    border: OutlineInputBorder(),
                  ),
                  items: controller.rxCleaningRooms.map((r) {
                    return DropdownMenuItem(
                      value: r.roomUuid,   // STRING VALUE
                      child: Text("Room ${r.number}"),
                    );
                  }).toList(),
                  onChanged: (val) {
                    selectedRoom.value =
                        controller.rxCleaningRooms.firstWhere((r) => r.roomUuid == val);
                  },
                ),

                const SizedBox(height: 15),

                // CLEANING TYPE
                DropdownButtonFormField<CleaningType>(
                  value: selectedType.value,
                  decoration: const InputDecoration(
                    labelText: "Cleaning Type",
                    border: OutlineInputBorder(),
                  ),
                  items: CleaningType.values.map((type) {
                    String label;
                    switch (type) {
                      case CleaningType.checkout:
                        label = "Checkout Cleaning";
                        break;
                      case CleaningType.stayover:
                        label = "Stayover Cleaning";
                        break;
                      case CleaningType.manual:
                        label = "Manual Cleaning";
                        break;
                    }

                    return DropdownMenuItem<CleaningType>(
                      value: type,
                      child: Text(label),
                    );
                  }).toList(),
                  onChanged: (val) => selectedType.value = val!,
                ),

              ],
            ),
          ),
        );
      }),

      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Get.back(),
        ),

        ElevatedButton(
          child: const Text("Assign"),
          onPressed: () {
            if (selectedStaff.value == null) {
              Get.snackbar("Error", "Please select staff");
              return;
            }
            if (selectedRoom.value == null) {
              Get.snackbar("Error", "Please select room");
              return;
            }

            controller.assignTask(
              staff: selectedStaff.value!,
              room: selectedRoom.value!,
              type: selectedType.value,   // ✅ CleaningType ENUM
            );


            Get.back();
          },
        ),
      ],
    );
  }
}
