import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/util/snackbar_util.dart';
import '../../../../model/entity_room.dart';
import '../../../../objectbox.g.dart';
import '../../../../service/service_object_box.dart';

class RoomChangeDialog extends StatelessWidget {
  final EntityRoom currentRoom;

  /// ✅ Now also returns REASON
  final Function(EntityRoom room, String reason) onRoomSelected;

  RoomChangeDialog({
    required this.currentRoom,
    required this.onRoomSelected,
  });

  final TextEditingController reasonCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final boxRoom = Get.find<ServiceObjectBox>().store.box<EntityRoom>();

    final availableRooms = boxRoom
        .query(EntityRoom_.status.equals("available"))
        .build()
        .find();

    return AlertDialog(
      title: const Text("Change Room"),
      content: SizedBox(
        width: 550,
        height: 500,
        child: Column(
          children: [
            /// ✅ REASON FIELD
            TextField(
              controller: reasonCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Reason for changing room",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            const Divider(),

            Expanded(
              child: ListView(
                children: availableRooms.map((room) {
                  final facilities = _parseFacilities(room.facilitiesJson);

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.meeting_room),
                      title: Text(
                        "Room ${room.number}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Type: ${room.roomType ?? room.type ?? "-"}"),
                          Text("Price: ₹${room.price?.toStringAsFixed(2) ?? "0"}"),
                          Text("Bed: ${room.bedType ?? "-"}"),
                          Text("Capacity: ${room.capacity ?? "-"}"),

                          if (facilities.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            const Text(
                              "Facilities:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Wrap(
                              spacing: 6,
                              children: facilities
                                  .map((f) => Chip(
                                label: Text(f),
                                visualDensity: VisualDensity.compact,
                              ))
                                  .toList(),
                            ),
                          ],
                        ],
                      ),
                      trailing: ElevatedButton(
                        child: const Text("Select"),
                        onPressed: () {
                          if (reasonCtrl.text.trim().isEmpty) {
                            SnackbarUtil.showError(
                              "Reason Required"
                             " Please enter reason to change room");
                            return;
                          }

                          onRoomSelected(room, reasonCtrl.text.trim());
                          Get.back();
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel"),
        ),
      ],
    );
  }

  /// ✅ Decode facilities from JSON
  List<String> _parseFacilities(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return [];

    try {
      final List data = json.decode(jsonStr);
      return data.map((e) => e.toString()).toList();
    } catch (_) {
      return [];
    }
  }
}
