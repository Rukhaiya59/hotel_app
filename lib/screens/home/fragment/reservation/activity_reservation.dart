import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/model/entity_booking.dart';
import 'package:hotel/model/entity_room.dart';
import 'package:hotel/screens/booking/activity_booking.dart';
import 'package:hotel/util/app_color.dart';

import 'controller_reservation.dart';

class ActivityReservationDetail extends StatelessWidget {
  final EntityBooking booking;

  const ActivityReservationDetail({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final reservationCtrl = Get.find<ControllerReservation>();

    // SAFE ROOM FETCH
    final EntityRoom? room = booking.room.target;

    // SAFE FIRST GUEST
    final guest = booking.guest.isNotEmpty ? booking.guest.first : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reservation Details"),
        backgroundColor: LightColor.primaryStart,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ░░░░░░░░ ROOM DETAILS ░░░░░░░░
            _sectionTitle("Room Details"),
            Card(
              child: ListTile(
                leading: const Icon(Icons.meeting_room, color: Colors.blue),
                title: Text(
                  "Room: ${room?.number ?? room?.number ?? 'N/A'}",
                ),
                subtitle: Text("Status: ${room?.status ?? 'N/A'}"),
              ),
            ),

            const SizedBox(height: 20),

            // ░░░░░░░░ GUEST DETAILS ░░░░░░░░
            _sectionTitle("Guest Details"),
            if (guest != null)
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade300,
                    child: Text(
                      guest.first.isNotEmpty ? guest.first[0] : "?",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text("${guest.first} ${guest.last}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Phone: ${guest.phone ?? 'N/A'}"),
                      Text("Email: ${guest.email ?? 'N/A'}"),
                      Text("Type: ${guest.guestType}"),
                    ],
                  ),
                ),
              )
            else
              const Text("Guest not found."),

            const SizedBox(height: 20),

            // ░░░░░░░░ BOOKING DETAILS ░░░░░░░░
            _sectionTitle("Booking Details"),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _infoRow("Check-in", booking.checkInDate),
                    _infoRow("Check-out", booking.checkOutDate),
                    _infoRow("Status", booking.status),
                    _infoRow("Total Bill", "₹${booking.totalBill.toStringAsFixed(2)}"),
                    _infoRow("Discount", "₹${(booking.discountPrice ?? 0).toStringAsFixed(2)}"),
                    if (booking.notes != null)
                      _infoRow("Notes", booking.notes!),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ░░░░░░░░ ACTION BUTTONS ░░░░░░░░
            _sectionTitle("Actions"),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // CHECK-IN NOW
                ElevatedButton.icon(
                  onPressed: () async {
                    await reservationCtrl.autoCheckIn(booking);
                    Get.back();
                  },
                  icon: const Icon(Icons.login),
                  label: const Text("Check-in"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),

                // CANCEL RESERVATION
                ElevatedButton.icon(
                  onPressed: () async {
                    await reservationCtrl.cancelReservation(booking);
                    Get.back(); // Close detail screen
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text("Cancel"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),

                // EDIT RESERVATION (open booking screen)
                ElevatedButton.icon(
                  onPressed: () {
                    Get.to(() => ActivityBooking(editBooking: booking));
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // OPEN BOOKING SCREEN

          ],
        ),
      ),
    );
  }

  // ░░░ SMALL UI COMPONENTS ░░░
  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value),
        ],
      ),
    );
  }
}
