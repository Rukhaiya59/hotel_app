import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/entity_room.dart';
import '../../../objectbox.g.dart';
import '../../../service/service_object_box.dart';

class RoomChangeDialog extends StatelessWidget {
  final EntityRoom currentRoom;
  final Function(EntityRoom) onRoomSelected;

  RoomChangeDialog({
    required this.currentRoom,
    required this.onRoomSelected,
  });

  @override
  Widget build(BuildContext context) {
    final boxRoom = Get.find<ServiceObjectBox>().store.box<EntityRoom>();
    final availableRooms = boxRoom
        .query(EntityRoom_.status.equals("available"))
        .build()
        .find();

    return AlertDialog(
      title: Text("Change Room"),
      content: SizedBox(
        width: 500,
        height: 400,
        child: ListView(
          children: availableRooms.map((room) {
            return ListTile(
              leading: const Icon(Icons.meeting_room),
              title: Text("Room ${room.number}"),
              subtitle: Text("Type: ${room.type} | Price: ₹${room.price}"),
              trailing: ElevatedButton(
                child: const Text("Select"),
                onPressed: () {
                  onRoomSelected(room);
                  Get.back(); // close dialog
                },
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel"),
        )
      ],
    );
  }
}
