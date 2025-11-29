import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../reports/controller_daily_room_revenue.dart';
import '../../../../service/service_currency.dart';

class FragDailyRoomSales extends StatelessWidget {
  const FragDailyRoomSales({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ControllerDailyRoomSales());
    final currencyService = Get.find<ServiceCurrency>();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- TOP BAR: Date + Export ----------------
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Obx(() {
                final dateStr = DateFormat("dd/MM/yyyy")
                    .format(controller.selectedDate.value);

                return Row(
                  children: [
                    Text(
                      "Daily Sales by Room",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text("Date: $dateStr"),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () => controller.pickDate(context),
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: const Text("Change Date"),
                    ),
                    const SizedBox(width: 8),
                    // ElevatedButton.icon(
                    //   onPressed: controller.exportPdf,
                    //   icon: const Icon(Icons.picture_as_pdf),
                    //   label: const Text("Export PDF"),
                    // ),
                  ],
                );
              }),
            ),
          ),

          const SizedBox(height: 10),

          // ---------------- SUMMARY ----------------
          Obx(() {
            final symbol = currencyService.symbol;
            return Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Total Revenue",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$symbol${controller.totalRevenue.value.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Rooms: ${controller.rows.length}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 10),

          // ---------------- TABLE ----------------
          Expanded(
            child: Obx(() {
              final rows = controller.rows;
              final symbol = currencyService.symbol;

              if (rows.isEmpty) {
                return const Center(child: Text("No data for selected date"));
              }

              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Room")),
                    DataColumn(label: Text("Bookings")),
                    DataColumn(label: Text("Nights")),
                    DataColumn(label: Text("Revenue")),
                  ],
                  rows: rows.map((r) {
                    return DataRow(
                      cells: [
                        DataCell(Text(r.roomNumber)),
                        DataCell(Text(r.bookings.toString())),
                        DataCell(Text(r.nights.toString())),
                        DataCell(
                          Text(
                            "$symbol${r.revenue.toStringAsFixed(2)}",
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
