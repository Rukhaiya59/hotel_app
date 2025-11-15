import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../util/snackbar_util.dart';
import '../../../../widgets/text_bold.dart';
import '../../../../widgets/text_small.dart';
import '../../../room/activity_create_room.dart';
import '../../../room/controller_room.dart';
import 'package:hotel/service/service_currency.dart';


class FragHomeRoom extends StatelessWidget {
  const FragHomeRoom({super.key});

  @override
  Widget build(BuildContext context) {
    final ControllerRoom controller = Get.put(ControllerRoom());
    final currencyService = Get.find<ServiceCurrency>();//currency

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          children: [

            // Room grid list
            Flexible(
              child: Obx(() {
                final rooms = controller.rxListRooms;
                if (rooms.isEmpty) {
                  return const Center(
                    child: TextSmall(message: "No rooms found"),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Room Number + Icon
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: TextBold(
                                    message: 'Room ${room.number}',
                                  ),
                                ),
                                Icon(Icons.meeting_room_rounded),
                              ],
                            ),

                            // Room details
                            TextSmall(message: 'Type: ${room.type}'),
                            TextSmall(message: 'Bed: ${room.bedType}'),
                            Obx(() {
                              final symbol = currencyService.symbol;//currency
                              return TextSmall(
                                message: "Price: $symbol${room.price}",//currency
                              );
                            }),


                            // Amenities
                            if (room.amenities.isNotEmpty)
                              Wrap(
                                spacing: 4,
                                children: room.amenities
                                    .map(
                                      (a) => Chip(
                                    label: TextSmall(
                                      message: a.name.toString(),
                                    ),
                                    backgroundColor: Colors.blue.shade50,
                                  ),
                                )
                                    .toList(),
                              ),

                            const Spacer(),

                            // Action buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    debugPrint(
                                      "edit roomUuid: ${room.roomUuid}: ${json.encode(room.toMap())}",
                                    );
                                    bool? isSave = await Get.to(
                                          () => ActivityCreateRoom(
                                        roomUuid: room.roomUuid,
                                      ),
                                    );
                                    debugPrint("save room: isSave: $isSave");
                                    if (isSave == true) {
                                      SnackbarUtil.showSuccess(
                                        "Room updated successfully",
                                      );
                                      controller.getAllRooms();
                                    }
                                  },

                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Get.defaultDialog(
                                      title: "Delete Room",
                                      middleText: "Are you sure?",
                                      textCancel: "Cancel",
                                      textConfirm: "Delete",
                                      confirmTextColor: Colors.white,
                                      buttonColor: Colors.redAccent,
                                      onConfirm: () {
                                        controller.deleteRoom(room.roomId);
                                        Get.back();
                                        controller.getAllRooms();
                                        SnackbarUtil.showSuccess(
                                          "Room ${room.number} deleted successfully",
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? isSave = await Get.to(() => ActivityCreateRoom());
          debugPrint("save room: isSave: $isSave");
          if (isSave == true) {
            SnackbarUtil.showSuccess("Room updated successfully");
            controller.getAllRooms();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}