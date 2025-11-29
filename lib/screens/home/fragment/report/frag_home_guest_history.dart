import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/reports/controller_guest_history.dart';

class FragHomeGuestHistory extends StatelessWidget {
  const FragHomeGuestHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ControllerGuestHistory());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Guest History Report"),
        centerTitle: true,
      ),

      body: Row(
        children: [
          // ================= LEFT SIDE - GUEST LIST =================
          Expanded(
            flex: 1,
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search guest...",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: controller.searchGuests,
                  ),
                ),

                Expanded(
                  child: Obx(() {
                    if (controller.allGuests.isEmpty) {
                      return const Center(child: Text("No guests found"));
                    }
                    return ListView.builder(
                      itemCount: controller.allGuests.length,
                      itemBuilder: (_, i) {
                        final g = controller.allGuests[i];
                        return ListTile(
                          title: Text("${g.first} ${g.last}"),
                          subtitle: Text(g.phone.toString()),
                          onTap: () {
                            controller.loadGuestHistory(g);
                          },
                        );
                      },
                    );
                  }),
                )
              ],
            ),
          ),

          // ================= RIGHT SIDE - HISTORY LIST =================
          Expanded(
            flex: 2,
            child: Obx(() {
              if (controller.guestHistoryList.isEmpty) {
                return const Center(
                  child: Text("Select a guest to view history"),
                );
              }

              return ListView.builder(
                itemCount: controller.guestHistoryList.length,
                itemBuilder: (_, i) {
                  final item = controller.guestHistoryList[i];

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(
                          "Booking ID: ${item['bookingId']} | Room: ${item['room']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Check-in: ${item['checkIn']}"),
                          Text("Check-out: ${item['checkOut']}"),
                          Text("Total: ₹${item['total']} | Paid: ₹${item['paid']} | Pending: ₹${item['pending']}"),
                          Text("Status: ${item['status']}"),
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
    );
  }
}
