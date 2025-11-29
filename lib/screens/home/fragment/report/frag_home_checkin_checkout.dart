import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../reports/controller_checkin_checkout.dart';

class FragHomeCheckinCheckout extends StatelessWidget {
  const FragHomeCheckinCheckout({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ControllerCheckinCheckout());

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ---------------- TOP FILTER BAR ----------------
          _TopFilterBar(controller: controller),

          const SizedBox(height: 12),

          // ---------------- SUMMARY BOXES ----------------
          _SummaryRow(controller: controller),

          const SizedBox(height: 12),

          // ---------------- DATA TABLE ----------------
          Expanded(
            child: Obx(() {
              final list = controller.filteredList;

              if (list.isEmpty) {
                return const Center(child: Text("No records found"));
              }

              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final b = list[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text("ID: ${b.bookingId} - ${controller.getGuestName(b)}"),

                      subtitle: Text(
                        "Check-in:  ${controller.fmt(b.checkInDate)}\n"
                            "Check-out: ${controller.fmt(b.checkOutDate)}",
                      ),
                      trailing: SizedBox(
                        width: 90,
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          direction: Axis.vertical,
                          spacing: 2,
                          children: [
                            Text(
                              b.status,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            if (controller.isEarlyCheckin(b))
                              const Text(
                                "Early In",
                                style: TextStyle(color: Colors.orange, fontSize: 11),
                              ),
                            if (controller.isEarlyCheckout(b))
                              const Text(
                                "Early Out",
                                style: TextStyle(color: Colors.orange, fontSize: 11),
                              ),
                          ],
                        ),
                      ),

                    ),
                  );
                },
              );
            }),
          )
        ],
      ),
    );
  }
}

// ---------------------- TOP FILTER BAR -----------------------------
class _TopFilterBar extends StatelessWidget {
  final ControllerCheckinCheckout controller;

  const _TopFilterBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [

            // 🔍 Search Bar
            Expanded(
              child: TextField(
                onChanged: controller.applySearch,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search guest, room no, phone, booking ID...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // 📅 DATE FILTER
            DropdownButton<String>(
              value: "All Dates",
              items: const [
                DropdownMenuItem(value: "All Dates", child: Text("All Dates")),
                DropdownMenuItem(value: "Today", child: Text("Today")),
                DropdownMenuItem(value: "7 Days", child: Text("Last 7 Days")),
                DropdownMenuItem(value: "Month", child: Text("This Month")),
                DropdownMenuItem(value: "Custom", child: Text("Custom Range")),
              ],
              onChanged: controller.applyDateFilter,
            ),

            const SizedBox(width: 10),

            // 🏨 CHECK-IN FILTER
            DropdownButton<String>(
              value: "All Checkins",
              items: const [
                DropdownMenuItem(value: "All Checkins", child: Text("All Checkins")),
                DropdownMenuItem(value: "Checked-In", child: Text("Checked-In")),
                DropdownMenuItem(value: "Checked-Out", child: Text("Checked-Out")),
                DropdownMenuItem(value: "Early-In", child: Text("Early Check-in")),
                DropdownMenuItem(value: "Early-Out", child: Text("Early Check-out")),
              ],
              onChanged: controller.applyTypeFilter,
            ),

            const SizedBox(width: 10),

            ElevatedButton.icon(
              onPressed: () => controller.exportReportPdf(),
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("Export PDF"),
            ),


          ],
        ),
      ),
    );
  }
}

// ---------------------- SUMMARY ROW ------------------------------
class _SummaryRow extends StatelessWidget {
  final ControllerCheckinCheckout controller;
  const _SummaryRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      children: [
        _box("Check-ins", controller.totalCheckins.value),
        const SizedBox(width: 8),
        _box("Check-outs", controller.totalCheckouts.value),
        const SizedBox(width: 8),
        _box("Early In", controller.earlyCheckins.value),
        const SizedBox(width: 8),
        _box("Early Out", controller.earlyCheckouts.value),
      ],
    ));
  }

  Widget _box(String title, int value) {
    return Expanded(
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              Text("$value",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
