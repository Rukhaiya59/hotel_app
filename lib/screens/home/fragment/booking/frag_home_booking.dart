import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../enums/enum_room_status.dart';
import '../../../../widgets/text_bold.dart';
import '../../../../widgets/text_header.dart';
import '../../../../widgets/text_small.dart';
import '../../../booking/activity_booking.dart';
import '../../../room/maintenance/maintenance.dart';
import 'controller_recep_booking.dart';

class FragHomeBooking extends StatelessWidget {
  const FragHomeBooking({super.key});

  @override
  Widget build(BuildContext context) {
    final ControllerReceptionistBooking controller = Get.put(
      ControllerReceptionistBooking(),
    );

    return SafeArea(
      child: Obx(() {
        if (controller.allRooms.isEmpty) {
          return const Center(child: TextHeader(message: "No rooms available"));
        }

        return Padding(
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
            itemCount: controller.allRooms.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 8,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final room = controller.allRooms[index];
              final color = EnumRoomStatus.getColor(room.status.toString());

              return GestureDetector(
                onTap: () async {
                  if (room.status == EnumRoomStatus.blocked.name) {
                    Get.to(() => ActivityMaintenanceViewOnly(roomUuid: room.roomUuid!));
                    return;
                  }
                  await Get.to(() => ActivityBooking(), arguments: room);
                  controller.fetchRooms();
                },

                child: Card(
                  elevation: 4,
                  color: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBold(
                          message: room.number ?? "Room",
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextSmall(
                          message: "Type: ${room.type ?? '-'}",
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white70
                                : Colors.black87,
                          ),
                        ),

                        TextSmall(
                          message: "Bed: ${room.bedType ?? '-'}",
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white70
                                : Colors.black87,
                          ),
                        ),


                        const Spacer(),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              room.status ?? 'Unknown',
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
