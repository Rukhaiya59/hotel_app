import 'package:flutter/material.dart';

import '../fragment/booking_history/Frag_booking_history.dart';
import '../fragment/maintenance/activity_maintenance_history.dart';
import '../fragment/report/frag_home_booking_history.dart';
import 'frag_home_cleaning.dart';

class ActivityAllHistory extends StatefulWidget {
  const ActivityAllHistory({super.key});

  @override
  State<ActivityAllHistory> createState() => _ActivityHistoryTabsState();
}

class _ActivityHistoryTabsState extends State<ActivityAllHistory> {
  int selected = 0;

  final List<String> tabs = [

    "Booking History",
    "Cleaning History",
    "Maintenance History",
  ];

  final List<Widget> screens = [
    FragBookingHistory(),
    FragHousekeepingHistory(),
    ActivityMaintenanceHistory(),


  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP TABS --------------------------------------------------
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 10,
              children: List.generate(tabs.length, (i) {
                return GestureDetector(
                  onTap: () => setState(() => selected = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: selected == i
                          ? (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                          : (Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade800
                          : Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tabs[i],
                      style: TextStyle(
                        color: selected == i
                            ? (Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white)
                            : Theme.of(context).textTheme.bodyMedium!.color,
                        fontWeight: selected == i ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  )
                  );
              }),
            ),
          ),

          const SizedBox(height: 10),

          // BODY AREA -------------------------------------------------
          Expanded(
            child: IndexedStack(
              index: selected,
              children: screens,
            ),
          ),
        ],
      ),
    );
  }
}
