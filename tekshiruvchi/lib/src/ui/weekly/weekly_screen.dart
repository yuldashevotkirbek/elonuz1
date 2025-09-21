import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyScreen extends StatelessWidget {
  final List<double> screenHours;
  final List<double> distanceKm;
  final List<double> sleepHours;

  const WeeklyScreen({
    super.key,
    required this.screenHours,
    required this.distanceKm,
    required this.sleepHours,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Haftalik natijalar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ChartCard(title: 'Ekran (soat)', values: screenHours, color: Colors.blue),
          _ChartCard(title: 'Masofa (km)', values: distanceKm, color: Colors.green),
          _ChartCard(title: 'Uyqu (soat)', values: sleepHours, color: Colors.purple),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final List<double> values;
  final Color color;
  const _ChartCard({required this.title, required this.values, required this.color});

  @override
  Widget build(BuildContext context) {
    final days = List.generate(7, (i) => DateFormat.E('uz').format(DateTime.now().subtract(Duration(days: 6 - i))));
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= days.length) return const SizedBox.shrink();
                          return Text(days[idx], style: const TextStyle(fontSize: 10));
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    for (int i = 0; i < values.length; i++)
                      BarChartGroupData(x: i, barRods: [
                        BarChartRodData(toY: values[i], color: color, width: 12, borderRadius: BorderRadius.circular(4)),
                      ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

