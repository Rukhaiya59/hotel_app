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

  String cleanEnumString(String? value) {
    if (value == null) return "N/A";
    final clean = value.split('.').last;
    return clean[0].toUpperCase() + clean.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ControllerBookingHistory());
    final currencyService = Get.find<ServiceCurrency>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBar(
          title: const Text("Booking History"),
          automaticallyImplyLeading: false,
          centerTitle: false,
          elevation: 1,
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.filter_list), // Use a filter icon
              onSelected: (value) {
                controller.setFilter(value);
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: "Today",
                  child: Row(
                    children: const [
                      Icon(Icons.today, color: Colors.blue),
                      SizedBox(width: 10),
                      Text("Today"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: "This Week",
                  child: Row(
                    children: const [
                      Icon(Icons.calendar_view_week, color: Colors.blue),
                      SizedBox(width: 10),
                      Text("This Week"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: "This Month",
                  child: Row(
                    children: const [
                      Icon(Icons.calendar_month, color: Colors.blue),
                      SizedBox(width: 10),
                      Text("This Month"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: "Room Change",
                  child: Row(
                    children: const [
                      Icon(Icons.swap_horiz, color: Colors.orange),
                      SizedBox(width: 10),
                      Text("Room Change History"),
                    ],
                  ),
                ),

                PopupMenuItem(
                  value: "All",
                  child: Row(
                    children: const [
                      Icon(Icons.list, color: Colors.blue),
                      SizedBox(width: 10),
                      Text("All"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        Expanded(
          child: Obx(() {
            if (controller.filteredBookings.isEmpty) {
              return const Center(
                child: Text(
                  "No Bookings Found",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              );
            }

            if (controller.filter.value == "Room Change") {
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.roomChangeHistory.length,
                itemBuilder: (_, i) {
                  final h = controller.roomChangeHistory[i];

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextBold(
                            message: "Booking ID: ${h.bookingId}", style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 6),
                          _row(Icons.meeting_room, "Old Room: ${h.oldRoomNo}"),
                          _row(Icons.meeting_room_outlined,
                              "New Room: ${h.newRoomNo}"),
                          _row(Icons.login,
                              "Old Check-In: ${formatDate(h.oldRoomCheckIn)}"),
                          _row(Icons.logout,
                              "Old Check-Out: ${formatDate(h.oldRoomCheckOut)}"),
                          _row(Icons.login,
                              "New Check-In: ${formatDate(h.newRoomCheckIn)}"),
                          if (h.newRoomCheckOut != null)
                            _row(Icons.logout,
                                "New Check-Out: ${formatDate(h.newRoomCheckOut)}"),
                          const Divider(),
                          _row(Icons.info, "Reason: ${h.reason}"),
                          _row(Icons.update,
                              "Changed At: ${formatDate(h.changedAt)}"),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return RefreshIndicator(
              onRefresh: () => controller.fetchAllBookings(),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.filteredBookings.length,
                itemBuilder: (context, index) {
                  final booking = controller.filteredBookings[index];
                  final room = booking.room.target;
                  final guestList = booking.guest.toList();
                  final guestName =
                  guestList.isNotEmpty ? guestList.first.first : "N/A";

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextBold(
                            message:
                            "Room ${room?.number ?? 'N/A'} • Floor ${room?.floor ?? 'N/A'}", style: TextStyle(fontSize: 16),
                          ),

                          const SizedBox(height: 6),

                          _row(Icons.person, "Guest: $guestName"),
                          _row(Icons.category,
                              "Booking Type: ${cleanEnumString(booking.bookingType)}"),
                          _row(Icons.login,
                              "Check-In: ${formatDate(booking.checkInDate)}"),
                          _row(Icons.logout,
                              "Check-Out: ${formatDate(booking.checkOutDate)}"),
                          _row(Icons.currency_exchange,
                              "Total Bill: ${currencyService.symbol}${booking.totalBill.toStringAsFixed(2)}"),
                          _row(Icons.verified,
                              "Status: ${cleanEnumString(booking.status)}"),
                        ],
                      ),
                    ),
                  );
                },
              ),);
          }),
        ),

      ],
    );
  }

  Widget _row(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 18),
          const SizedBox(width: 6),
          TextSmall(message: text, style: TextStyle(fontSize: 14),),
        ],
      ),
    );
  }
}