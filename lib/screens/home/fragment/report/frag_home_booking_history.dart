import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/service/service_currency.dart';

import '../../../../reports/controller_booking_history.dart';

class FragHomeBookingHistory extends StatelessWidget {
  const FragHomeBookingHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ControllerBookingHistory());
    final currencyService = Get.find<ServiceCurrency>();
    final symbol = currencyService.symbol;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TopFilterBar(controller: controller),

          const SizedBox(height: 12),

          _SummaryRow(controller: controller, symbol: symbol),

          const SizedBox(height: 12),

          // LIST
          Expanded(
            child: Obx(() {
              final list = controller.filtered;
              if (list.isEmpty) {
                return const Center(child: Text("No bookings found"));
              }

              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final b = list[i];
                  final nights = controller.getNights(b);
                  final paid = controller.getPaid(b);
                  final pending = controller.getPending(b);

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // LEFT: BASIC + GUEST + STAY
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // BASIC
                                Text(
                                  "ID: ${b.bookingId}  |  Room: ${controller.getRoomNo(b)}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                                const SizedBox(height: 4),

                                // GUEST
                                Text(
                                  "${controller.getGuestName(b)} (${controller.getGuestPhone(b)})",
                                  style: const TextStyle(fontSize: 12),
                                ),

                                const SizedBox(height: 4),

                                // STAY
                                Text(
                                  "Check-in:  ${controller.fmt(b.checkInDate)}",
                                  style: const TextStyle(fontSize: 11),
                                ),
                                Text(
                                  "Check-out: ${controller.fmt(b.checkOutDate)}",
                                  style: const TextStyle(fontSize: 11),
                                ),
                                Text(
                                  "Nights: $nights",
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ),

                          // RIGHT: PRICE + PAYMENT + STATUS
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Total: $symbol${b.totalBill.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Discount: $symbol${b.discountPrice?.toStringAsFixed(2)}",
                                  style: const TextStyle(fontSize: 11),
                                ),
                                Text(
                                  "Paid: $symbol${paid.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.green),
                                ),
                                Text(
                                  "Pending: $symbol${pending.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.red),
                                ),
                                const SizedBox(height: 4),

                                // STATUS
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _statusColor(b.status),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    b.status,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                if ((b.notes ?? "").isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    "Note: ${b.notes}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ],
                            ),
                          )
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

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "checked-in":
        return Colors.orange;
      case "checked-out":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

// ---------------- TOP FILTER BAR ----------------
class _TopFilterBar extends StatelessWidget {
  final ControllerBookingHistory controller;

  const _TopFilterBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // 🔍 Search
            Expanded(
              child: TextField(
                onChanged: controller.applySearch,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search guest, phone, room, booking ID...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // 📅 Date filter
            DropdownButton<String>(
              value: "All",
              items: const [
                DropdownMenuItem(value: "All", child: Text("All Dates")),
                DropdownMenuItem(value: "Today", child: Text("Today")),
                DropdownMenuItem(value: "7 Days", child: Text("Last 7 Days")),
                DropdownMenuItem(value: "Month", child: Text("This Month")),
              ],
              onChanged: controller.applyDateFilter,
            ),

            const SizedBox(width: 8),

            // 📌 Status filter
            DropdownButton<String>(
              value: "All",
              items: const [
                DropdownMenuItem(value: "All", child: Text("All Status")),
                DropdownMenuItem(
                    value: "Checked-In", child: Text("Checked-In")),
                DropdownMenuItem(
                    value: "Checked-Out", child: Text("Checked-Out")),
                DropdownMenuItem(
                    value: "Cancelled", child: Text("Cancelled")),
              ],
              onChanged: controller.applyStatusFilter,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- SUMMARY ROW ----------------
class _SummaryRow extends StatelessWidget {
  final ControllerBookingHistory controller;
  final String symbol;

  const _SummaryRow({required this.controller, required this.symbol});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Row(
        children: [
          _box("Bookings", controller.totalBookings.value.toString()),
          const SizedBox(width: 8),
          _box(
              "Revenue", "$symbol${controller.totalRevenue.value.toStringAsFixed(2)}"),
          const SizedBox(width: 8),
          _box(
              "Discount", "$symbol${controller.totalDiscount.value.toStringAsFixed(2)}"),
          const SizedBox(width: 8),
          _box(
              "Paid", "$symbol${controller.totalPaid.value.toStringAsFixed(2)}"),
          const SizedBox(width: 8),
          _box(
              "Pending", "$symbol${controller.totalPending.value.toStringAsFixed(2)}"),
        ],
      ),
    );
  }

  Widget _box(String title, String value) {
    return Expanded(
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                title,
                style:
                const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
