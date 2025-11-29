import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseLineChart extends StatelessWidget {
  final List<double> data; // daily totals (7 or 30)

  const ExpenseLineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(),
          topTitles: AxisTitles(),
          rightTitles: AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (i, _) => Text(i.toInt().toString()),
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
                data.length, (i) => FlSpot(i.toDouble(), data[i])),
            isCurved: true,
            color: Colors.deepPurple,
            barWidth: 3,
          ),
        ],
      ),
    );
  }
}
