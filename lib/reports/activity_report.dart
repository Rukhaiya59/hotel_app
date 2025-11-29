import 'package:flutter/material.dart';
import 'package:hotel/screens/home/fragment/report/frag_home_guest_history.dart';
import 'package:hotel/screens/home/fragment/report/frag_home_payment.dart';

import '../screens/home/fragment/report/frag_home_booking_history.dart';
import '../screens/home/fragment/report/frag_home_checkin_checkout.dart';
import '../screens/home/fragment/report/frag_home_daily_room_revenue.dart';
import '../screens/home/fragment/report/frag_home_inventorys.dart';
import '../screens/home/fragment/report/frag_home_occupancy.dart';


class ActivityReport extends StatefulWidget {
  const ActivityReport({super.key});

  @override
  State<ActivityReport> createState() => _PageReportsState();
}

class _PageReportsState extends State<ActivityReport> {
  int selected = 0;
  final List<String> reportTabs = [
    "Occupancy",
    "Payment",
    "Check-in / Check-out",
    "Room Revenue",
    "Booking History",
    "Guest History",
    "Inventory",
  ];

  final List<Widget> reportScreens = [
    FragHomeOccupancy(),
     FragHomePayment(),
    FragHomeCheckinCheckout(),
    FragDailyRoomSales(),
    FragHomeBookingHistory(),
    FragHomeGuestHistory(),
    FragHomeInventorys(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports"),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP TABS --------------------------------------------------
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 10,
              children: List.generate(reportTabs.length, (i) {
                return GestureDetector(
                  onTap: () => setState(() => selected = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: selected == i
                          ? Colors.white
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      reportTabs[i],
                      style: TextStyle(
                        fontWeight: selected == i
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 10),

          // BODY AREA -------------------------------------------------
          Expanded(
            child: IndexedStack(
              index: selected,
              children: reportScreens,
            ),
          ),
        ],
      ),
    );
  }
}
