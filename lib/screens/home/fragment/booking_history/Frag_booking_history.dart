import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../service/service_currency.dart';
import '../../../../widgets/text_bold.dart';
import '../../../../widgets/text_small.dart';
import 'controller_booking_history.dart';

class FragBookingHistory extends StatelessWidget {
  const FragBookingHistory({super.key});

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "N/A";
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  /// Format enum-like string (e.g. EnumBookingStatus.confirmed)
  String cleanEnumString(String? value) {
    if (value == null) return "N/A";
    final parts = value.split('.');
    final clean = parts.isNotEmpty ? parts.last : value;
    return clean[0].toUpperCase() + clean.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final ControllerBookingHistory controller =
    Get.put(ControllerBookingHistory());
    final currencyService = Get.find<ServiceCurrency>();//currency
    final symbol = currencyService.symbol;//currency


    return Obx(() {
      if (controller.allBookings.isEmpty) {
        return const Center(
          child: Text(
            "No Bookings Found",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.allBookings.length,
        itemBuilder: (context, index) {
          final booking = controller.allBookings[index];

          // ✅ Fetch room and guest info
          final room = booking.room.target;
          final guestList = booking.guest.toList();
          final guestName = guestList.isNotEmpty ? guestList.first.first : "N/A";

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Room info & delete
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextBold(
                        message:
                        "Room ${room?.number ?? 'N/A'} • Floor ${room?.floor ?? 'N/A'}",
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          Get.defaultDialog(
                            title: "Confirm Delete",
                            middleText:
                            "Are you sure you want to delete this booking?",
                            textConfirm: "Yes",
                            textCancel: "No",
                            confirmTextColor: Colors.white,
                            onConfirm: () {
                              controller.deleteBooking(booking.bookingId);
                              Get.back();
                            },
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  //  Guest info
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.blue, size: 18),
                      const SizedBox(width: 6),
                      TextSmall(message: "Guest: $guestName"),
                    ],
                  ),

                  const SizedBox(height: 4),

                  //  Booking Type
                  Row(
                    children: [
                      const Icon(Icons.category,
                          color: Colors.deepPurpleAccent, size: 18),
                      const SizedBox(width: 6),
                      TextSmall(
                          message:
                          "Booking Type: ${cleanEnumString(booking.bookingType)}"),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // 📅 Check-in/out
                  Row(
                    children: [
                      const Icon(Icons.login, color: Colors.green, size: 18),
                      const SizedBox(width: 6),
                      TextSmall(
                          message: "Check-In: ${formatDate(booking.checkInDate)}"),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.logout, color: Colors.orange, size: 18),
                      const SizedBox(width: 6),
                      TextSmall(
                          message:
                          "Check-Out: ${formatDate(booking.checkOutDate)}"),
                    ],
                  ),

                  const SizedBox(height: 6),

                  //  Total amount
                  Row(
                    children: [
                      const Icon(Icons.currency_exchange,
                          color: Colors.black87, size: 18),
                      const SizedBox(width: 6),
                      TextSmall(
                          message: "Total Bill: $symbol${booking.totalBill.toStringAsFixed(2)}"),//currency

                    ],
                  ),

                  const SizedBox(height: 6),

                  //  Status (cleaned)
                  Row(
                    children: [
                      const Icon(Icons.verified, color: Colors.teal, size: 18),
                      const SizedBox(width: 6),
                      TextSmall(
                        message:
                        "Status: ${cleanEnumString(booking.status)}",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}