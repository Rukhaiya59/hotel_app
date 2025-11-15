import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../enums/enum_room_status.dart';
import '../../../../service/service_currency.dart';
import 'controller_dashboard.dart';

class FragHomeDashboard extends StatelessWidget {
  const FragHomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final reportCtrl = Get.put(ControllerDashboard());
    final currencyService = Get.find<ServiceCurrency>();


    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            tooltip: "Filter by Date Range",
            onPressed: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2023),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                reportCtrl.fetchReportData(
                  start: picked.start,
                  end: picked.end,
                );
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (reportCtrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final statusMap = reportCtrl.roomStatusCount;
        final monthlyRev = reportCtrl.monthlyRevenueMap; // ✅ FIXED

        return RefreshIndicator(
          onRefresh: () async => reportCtrl.fetchReportData(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ----------------- REVENUE SUMMARY -----------------
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          const Text(
                            "Revenue Summary",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _miniBox("Daily", reportCtrl.dailyRevenue.value, Colors.orange, currencyService.symbol),
                              _miniBox("Weekly", reportCtrl.weeklyRevenue.value, Colors.purple, currencyService.symbol),
                              _miniBox("Monthly", reportCtrl.monthlyRevenue.value, Colors.teal, currencyService.symbol),
                              _miniBox("Total", reportCtrl.totalRevenue.value, Colors.green, currencyService.symbol),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ---------------- BOOKINGS SUMMARY ----------------
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          const Text(
                            "Bookings Summary",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _miniBox(
                                "Daily",
                                reportCtrl.dailyBookings.value.toDouble(),
                                Colors.orangeAccent,
                                '',
                              ),
                              _miniBox(
                                "Weekly",
                                reportCtrl.weeklyBookings.value.toDouble(),
                                Colors.purpleAccent,
                                '',
                              ),
                              _miniBox(
                                "Monthly",
                                reportCtrl.monthlyBookings.value.toDouble(),
                                Colors.tealAccent,
                                '',
                              ),
                              _miniBox("Total",
                                  reportCtrl.totalBookings.value.toDouble(), Colors.blue, ''),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // ---------------- PIE CHART + BAR GRAPH ----------------
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // PIE CHART
                    Expanded(
                      flex: 1,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Text(
                                "Room Status Overview",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (statusMap.isEmpty)
                                const Text(
                                  "No Room Data Found",
                                  style: TextStyle(color: Colors.grey),
                                )
                              else
                                SizedBox(
                                  height: 220,
                                  child: PieChart(
                                    PieChartData(
                                      centerSpaceRadius: 45,
                                      sectionsSpace: 3,
                                      sections: _buildPieSections(statusMap),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 10,
                                children: statusMap.entries.map((e) {
                                  final s = EnumRoomStatus.getColor(e.key);
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 6,
                                        backgroundColor: s,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${e.key} (${e.value})",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // BAR GRAPH
                    Expanded(
                      flex: 1,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Text(
                                "Monthly Revenue Trend",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (monthlyRev.isEmpty)
                                const Text(
                                  "No Revenue Data Found",
                                  style: TextStyle(color: Colors.grey),
                                )
                              else
                                SizedBox(
                                  height: 220,
                                  child: BarChart(
                                    BarChartData(
                                      gridData: FlGridData(
                                        drawVerticalLine: false,
                                      ),
                                      borderData: FlBorderData(show: false),
                                      barGroups: monthlyRev.entries
                                          .map(
                                            (e) => BarChartGroupData(
                                          x: monthlyRev.keys
                                              .toList()
                                              .indexOf(e.key),
                                          barRods: [
                                            BarChartRodData(
                                              toY: e.value,
                                              color: Colors.blueAccent,
                                              width: 14,
                                              borderRadius:
                                              BorderRadius.circular(4),
                                            ),
                                          ],
                                        ),
                                      )
                                          .toList(),
                                      titlesData: FlTitlesData(
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 30,
                                            getTitlesWidget: (value, meta) {
                                              if (value >= 0 &&
                                                  value <
                                                      monthlyRev.keys.length
                                                          .toDouble()) {
                                                return Text(
                                                  monthlyRev.keys.elementAt(
                                                    value.toInt(),
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                );
                                              }
                                              return const Text('');
                                            },
                                          ),
                                        ),
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            interval: 1000,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ---------------- DATE RANGE INFO ----------------
                if (reportCtrl.startDate != null && reportCtrl.endDate != null)
                  Center(
                    child: Text(
                      "Report: ${DateFormat('dd MMM').format(reportCtrl.startDate!)} - ${DateFormat('dd MMM yyyy').format(reportCtrl.endDate!)}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// ------- Mini box for revenues & bookings -------
  Widget _miniBox(String label, double value, Color color, String prefix) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1), // ✅ modern API
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "$prefix${value.toStringAsFixed(0)}",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// ------- Pie sections with nice colors -------
  List<PieChartSectionData> _buildPieSections(Map<String, int> statusMap) {
    final total = statusMap.values.fold<int>(0, (a, b) => a + b);
    return statusMap.entries.map((e) {
      final s = EnumRoomStatus.getColor(e.key);
      final percent = total == 0 ? 0 : (e.value / total) * 100;
      return PieChartSectionData(
        color: s,
        value: e.value.toDouble(),
        title: "${percent.toStringAsFixed(1)}%",
        radius: 60,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );
    }).toList();
  }
}