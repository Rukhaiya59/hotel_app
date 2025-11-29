import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../model/entity_booking.dart';
import '../../../../model/entity_room.dart';
import '../../../../service/service_object_box.dart';
import '../../../../util/app_color.dart';
import '../../../reservation/reservation_calender.dart';
import 'activity_reservation.dart';
import 'controller_reservation.dart';

class FragHomeReservation extends StatelessWidget {
  FragHomeReservation({super.key});

  final store = Get.find<ServiceObjectBox>().store;
  final controller = Get.put(ControllerReservation());

  final ValueNotifier<List<EntityBooking>> upcomingReservations =
  ValueNotifier([]);

  // ───────────────────────────────────────────────
  // LOAD ALL FUTURE RESERVATIONS
  // ───────────────────────────────────────────────
  void loadData() {
    final boxBooking = store.box<EntityBooking>();
    final all = boxBooking.getAll();

    final now = DateTime.now();
    final upcoming = <EntityBooking>[];

    for (var b in all) {
      try {
        final ci = DateTime.parse(b.checkInDate);

        if (ci.isAfter(now)) {
          upcoming.add(b);
        }
      } catch (_) {}
    }

    upcomingReservations.value = upcoming;
  }

  @override
  Widget build(BuildContext context) {
    // AUTO LOAD EVERY BUILD
    loadData();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // ───────────────────────────────────────────────
          // TOP BUTTON — CALENDAR VIEW
          // ───────────────────────────────────────────────
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Get.to(() => ReservationCalendarScreen(store: store));
                },
                icon: const Icon(Icons.calendar_month),
                label: const Text("Calendar View"),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ───────────────────────────────────────────────
          // TITLE
          // ───────────────────────────────────────────────
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Upcoming Reservations",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: LightColor.primaryStart,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ───────────────────────────────────────────────
          // UPCOMING RESERVATIONS LIST
          // ───────────────────────────────────────────────
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: upcomingReservations,
              builder: (_, list, __) {
                if (list.isEmpty) {
                  return const Center(
                    child: Text("No upcoming reservations"),
                  );
                }

                return Card(
                  elevation: 2,
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final b = list[i];
                      final EntityRoom? room = b.room.target;

                      return ListTile(
                        leading: const Icon(
                          Icons.event_available,
                          color: Colors.amber,
                        ),

                        // FIXED room.number ISSUE
                        title: Text(
                          "Room: ${room?.number ?? 'N/A'}   •   ₹${b.totalBill.toStringAsFixed(2)}",
                        ),

                        subtitle: Text(
                          "${b.checkInDate} → ${b.checkOutDate}\nStatus: ${b.status}",
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // OPEN DETAIL SCREEN
                            IconButton(
                              icon: const Icon(Icons.open_in_new),
                              onPressed: () {
                                Get.to(
                                      () => ActivityReservationDetail(booking: b),
                                );
                              },
                            ),

                            // CANCEL RESERVATION
                            IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              onPressed: () async {
                                await controller.cancelReservation(b);
                                loadData(); // refresh UI
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
