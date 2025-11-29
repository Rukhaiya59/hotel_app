import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChargeableBarChart extends StatelessWidget {
  final List<double> data; // 7 values (Mon–Sun)

  const ChargeableBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: data.reduce((a, b) => a > b ? a : b) + 20,
        barTouchData: BarTouchData(enabled: true),
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(),
          topTitles: AxisTitles(),
          rightTitles: AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (i, _) {
                const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
                return Text(days[i.toInt()]);
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(
          data.length,
              (i) => BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                width: 18,
                toY: data[i],
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
