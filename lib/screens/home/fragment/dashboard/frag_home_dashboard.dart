import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hotel/enums/enum_room_status.dart';
import 'package:hotel/service/service_currency.dart';
import 'controller_dashboard.dart';

class FragHomeDashboard extends StatelessWidget {
  const FragHomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboard = Get.put(ControllerDashboard());
    final currencyService = Get.find<ServiceCurrency>();
    final symbol = currencyService.symbol;

    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.white;
    final fadedText = textColor.withOpacity(0.6);
    final cardColor = theme.cardColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "Hotel Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: textColor),
            onPressed: () => dashboard.fetchReportData(),
          ),
          IconButton(
            tooltip: "Filter by Date Range",
            icon: Icon(Icons.date_range, color: textColor),
            onPressed: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2023),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                dashboard.fetchReportData(
                  start: picked.start,
                  end: picked.end,
                );
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (dashboard.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final statusMap = dashboard.roomStatusCount;
        final monthlyRev = dashboard.monthlyRevenueMap;
        final weekRev = dashboard.weekRevenue.isEmpty
            ? List<double>.filled(7, 0)
            : dashboard.weekRevenue;

        return RefreshIndicator(
          onRefresh: () async => dashboard.fetchReportData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- SUMMARY ROW ----------
                Row(
                  children: [
                    Expanded(
                      child: _summaryCardRow(
                        title: "Revenue",
                        textColor: textColor,
                        fadedText: fadedText,
                        cards: [
                          _SummaryItem("Today", dashboard.dailyRevenue.value, symbol),
                          _SummaryItem("This Week", dashboard.weeklyRevenue.value, symbol),
                          _SummaryItem("This Month", dashboard.monthlyRevenue.value, symbol),
                          _SummaryItem("Total", dashboard.totalRevenue.value, symbol),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _summaryCardRow(
                        title: "Bookings",
                        textColor: textColor,
                        fadedText: fadedText,
                        cards: [
                          _SummaryItem("Today", dashboard.dailyBookings.value.toDouble(), ""),
                          _SummaryItem("This Week", dashboard.weeklyBookings.value.toDouble(), ""),
                          _SummaryItem("This Month", dashboard.monthlyBookings.value.toDouble(), ""),
                          _SummaryItem("Total", dashboard.totalBookings.value.toDouble(), ""),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ---------- GRAPHS ----------
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _graphCard(
                        title: "Weekly Room Sales",
                        subtitle: "Last 7 days",
                        child: SizedBox(
                          height: 220,
                          child: LineChart(
                            _lineChartData(
                              weekRev,
                              dashboard.weekDays,
                              theme,
                            ),
                          ),
                        ),
                        theme: theme,
                        textColor: textColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: _graphCard(
                        title: "Cashflow",
                        subtitle: "Inflow",
                        child: SizedBox(
                          height: 220,
                          child: LineChart(
                            _cashflowData(
                              inflow: dashboard.weekInflow,
                              outflow: dashboard.weekOutflow,
                              labels: dashboard.weekDays,
                              theme: theme,
                            ),
                          ),
                        ),
                        theme: theme,
                        textColor: textColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ---------- BOTTOM GRAPHS ----------
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _graphCard(
                        title: "Room Occupancy",
                        subtitle: "Live status",
                        theme: theme,
                        textColor: textColor,
                        child: statusMap.isEmpty
                            ? SizedBox(
                          height: 180,
                          child: Center(
                            child: Text("No room data", style: TextStyle(color: fadedText)),
                          ),
                        )
                            : SizedBox(
                          height: 220,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 3,
                              centerSpaceRadius: 48,
                              sections: _buildPieSections(statusMap, textColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: _graphCard(
                        title: "Monthly Revenue Trend",
                        subtitle: "This year",
                        theme: theme,
                        textColor: textColor,
                        child: SizedBox(
                          height: 220,
                          child: monthlyRev.isEmpty
                              ? Center(
                            child: Text("No revenue data", style: TextStyle(color: fadedText)),
                          )
                              : BarChart(_monthlyRevenueBarData(monthlyRev, theme)),
                        ),
                      ),
                    ),
                  ],
                ),

                if (dashboard.startDate != null)
                  Center(
                    child: Text(
                      "${DateFormat('dd MMM').format(dashboard.startDate!)} - "
                          "${DateFormat('dd MMM yyyy').format(dashboard.endDate!)}",
                      style: TextStyle(color: fadedText, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ---------------------------------------------------------------------------
  // Summary Cards Row
  // ---------------------------------------------------------------------------

  Widget _summaryCardRow({
    required String title,
    required Color textColor,
    required Color fadedText,
    required List<_SummaryItem> cards,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: fadedText, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Row(
          children: cards
              .map((c) => Expanded(child: _miniBox(c.label, c.value, c.prefix, textColor)))
              .toList(),
        ),
      ],
    );
  }

  Widget _miniBox(String label, double value, String prefix, Color textColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(10),
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12)),
          const Spacer(),
          Text(
            "$prefix${value.toStringAsFixed(value == value.roundToDouble() ? 0 : 2)}",
            style: TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Graph card
  // ---------------------------------------------------------------------------

  Widget _graphCard({
    required String title,
    required Widget child,
    required ThemeData theme,
    required Color textColor,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: textColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.w600)),
          if (subtitle != null)
            Text(subtitle, style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 11)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Charts
  // ---------------------------------------------------------------------------

  LineChartData _lineChartData(List<double> values, List<String> labels, ThemeData theme) {
    final color = theme.colorScheme.secondary;

    return LineChartData(
      minX: 0,
      maxX: 6,
      minY: 0,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(values.length, (i) => FlSpot(i.toDouble(), values[i])),
          isCurved: true,
          color: color,
          barWidth: 3,
          dotData: FlDotData(show: false),
        ),
      ],
    );
  }

  LineChartData _cashflowData({
    required List<double> inflow,
    required List<double> outflow,
    required List<String> labels,
    required ThemeData theme,
  }) {
    return LineChartData(
      minX: 0,
      maxX: 6,
      minY: 0,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(inflow.length, (i) => FlSpot(i.toDouble(), inflow[i])),
          isCurved: true,
          color: Colors.greenAccent,
          barWidth: 3,
          dotData: FlDotData(show: false),
        ),
      ],
    );
  }

  BarChartData _monthlyRevenueBarData(Map<String, double> monthMap, ThemeData theme) {
    final color = theme.colorScheme.primary;

    return BarChartData(
      barGroups: monthMap.entries.toList().asMap().entries.map((entry) {
        final index = entry.key;
        final data = entry.value;
        return BarChartGroupData(
          x: index,
          barRods: [BarChartRodData(toY: data.value, color: color, width: 14)],
        );
      }).toList(),
    );
  }

  List<PieChartSectionData> _buildPieSections(Map<String, int> map, Color textColor) {
    final total = map.values.fold(0, (a, b) => a + b);
    return map.entries.map((e) {
      final percent = (e.value / total) * 100;
      return PieChartSectionData(
        value: e.value.toDouble(),
        color: EnumRoomStatus.getColor(e.key),
        radius: 55,
        title: "${percent.toStringAsFixed(1)}%",
        titleStyle: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.bold),
      );
    }).toList();
  }
}

class _SummaryItem {
  final String label;
  final double value;
  final String prefix;
  _SummaryItem(this.label, this.value, this.prefix);
}
