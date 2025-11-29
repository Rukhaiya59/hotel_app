import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class VendorPieChart extends StatelessWidget {
  final Map<String, int> data;

  const VendorPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final values = data.values.toList();
    final labels = data.keys.toList();

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: List.generate(values.length, (i) {
          return PieChartSectionData(
            color: Colors.accents[i % Colors.accents.length],
            value: values[i].toDouble(),
            title: "",
            radius: 45,
          );
        }),
      ),
    );
  }
}
