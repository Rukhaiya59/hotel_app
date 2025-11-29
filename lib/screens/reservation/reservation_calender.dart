import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';
import '../../objectbox.g.dart';
import '../../model/entity_booking.dart';
import '../../model/entity_room.dart';
import '../../util/app_color.dart';
import '../home/fragment/reservation/activity_reservation.dart';

class ReservationCalendarScreen extends StatelessWidget {
  final Store store;

  const ReservationCalendarScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final boxBooking = store.box<EntityBooking>();
    final boxRoom = store.box<EntityRoom>();

    /// State holders for Stateless widget
    final ValueNotifier<DateTime> focusedDay = ValueNotifier(DateTime.now());
    final ValueNotifier<DateTime?> selectedDay = ValueNotifier(DateTime.now());
    final ValueNotifier<Map<DateTime, List<EntityBooking>>> events =
    ValueNotifier({});

    /// Load Events Function
    void loadEvents() {
      final map = <DateTime, List<EntityBooking>>{};
      final all = boxBooking.getAll();

      for (var b in all) {
        try {
          final ci = DateTime.parse(b.checkInDate);
          final co = DateTime.parse(b.checkOutDate);

          for (DateTime d = DateTime(ci.year, ci.month, ci.day);
          d.isBefore(DateTime(co.year, co.month, co.day));
          d = d.add(const Duration(days: 1))) {
            final key = DateTime(d.year, d.month, d.day);
            map.putIfAbsent(key, () => []).add(b);
          }
        } catch (_) {}
      }

      events.value = map;
    }

    /// Load events once
    loadEvents();

    /// Helper - get events for day
    List<EntityBooking> getEvents(DateTime day) {
      final key = DateTime(day.year, day.month, day.day);
      return events.value[key] ?? [];
    }

    /// Helper - day color logic
    Color dayColor(DateTime day) {
      final list = getEvents(day);
      if (list.isEmpty) return Colors.transparent;

      bool occupied = list.any((b) =>
      b.status.toLowerCase() == "checkedin" ||
          b.status.toLowerCase() == "confirmed");

      return occupied ? Colors.red.shade300 : Colors.amber.shade300;
    }

    /// Auto Check-in Action
    void autoCheckIn(EntityBooking b) {
      b.status = 'checkedin';
      b.actualCheckInAt = DateTime.now.toString();
      boxBooking.put(b);

      final room = b.room.target;
      if (room != null) {
        room.status = "busy";
        room.bookingUuid = b.bookingUuid;
        boxRoom.put(room);
      }

      loadEvents();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Checked in")));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reservation Calendar"),
        backgroundColor: LightColor.primaryStart,
      ),

      /// MAIN UI
      body: Column(
        children: [
          /// Calendar Section
          ValueListenableBuilder(
            valueListenable: events,
            builder: (_, __, ___) {
              return ValueListenableBuilder<DateTime?>(
                valueListenable: selectedDay,
                builder: (_, selDay, __) {
                  return ValueListenableBuilder<DateTime>(
                    valueListenable: focusedDay,
                    builder: (_, focDay, __) {
                      return TableCalendar(
                        firstDay: DateTime.now().subtract(const Duration(days: 365)),
                        lastDay: DateTime.now().add(const Duration(days: 365)),
                        focusedDay: focDay,
                        selectedDayPredicate: (d) => isSameDay(d, selDay),
                        onDaySelected: (d, f) {
                          selectedDay.value = d;
                          focusedDay.value = f;
                        },
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, _) {
                            return Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: dayColor(day),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              alignment: Alignment.center,
                              child: Text("${day.day}"),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),

          const SizedBox(height: 8),

          /// Reservation List
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: selectedDay,
              builder: (_, selDay, __) {
                selDay ??= DateTime.now();
                final list = getEvents(selDay);

                if (list.isEmpty) {
                  return Center(
                      child: Text(
                          "No reservations on ${selDay.toString().split(' ')[0]}"));
                }

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final b = list[i];

                    final now = DateTime.now();
                    DateTime ci = DateTime.tryParse(b.checkInDate) ?? now;

                    bool canAutoCheckIn =
                        !ci.isAfter(now) && b.status.toLowerCase() == "reserved";

                    return ListTile(
                      leading: const Icon(Icons.hotel),
                      title: Text(
                          "Booking: ${b.bookingUuid} - ₹${b.totalBill.toStringAsFixed(2)}"),
                      subtitle: Text(
                          "${b.checkInDate} → ${b.checkOutDate}\nStatus: ${b.status}"),
                      trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (canAutoCheckIn)
                              TextButton.icon(
                                onPressed: () => autoCheckIn(b),
                                icon: const Icon(Icons.login),
                                label: const Text("Auto Check-in"),
                              ),
                            IconButton(
                              onPressed: () {
                                Get.to(
                                      () => ActivityReservationDetail(booking: b),
                                );
                                // Navigate to booking details screen
                              },
                              icon: const Icon(Icons.open_in_new),
                            ),
                          ]
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
