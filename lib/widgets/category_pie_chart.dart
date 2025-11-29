import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<String, double> data;

  const CategoryPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final sections = data.entries.map((e) {
      return PieChartSectionData(
        title: e.key,
        value: e.value,
        radius: 40,
        color: Colors.primaries[data.keys.toList().indexOf(e.key) % Colors.primaries.length],
      );
    }).toList();

    return PieChart(PieChartData(
      sectionsSpace: 2,
      centerSpaceRadius: 35,
      sections: sections,
    ));
  }
}
