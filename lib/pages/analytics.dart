import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final CollectionReference _logsCollection =
  FirebaseFirestore.instance.collection('food_logs');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(32, 42, 68, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(32, 42, 68, 1),
        title: const Text('Analytics', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _logsCollection.orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text('No data available.',
                    style: TextStyle(color: Colors.white)));
          }

          final logs = snapshot.data!.docs;

          // Aggregate data by date
          Map<String, Map<String, double>> aggregatedData = {};
          for (var log in logs) {
            final data = log.data() as Map<String, dynamic>;
            final timestamp = (data['timestamp'] as Timestamp).toDate();
            final dateKey = DateFormat('yyyy-MM-dd').format(timestamp);

            if (!aggregatedData.containsKey(dateKey)) {
              aggregatedData[dateKey] = {
                'calories': 0.0,
                'protein': 0.0,
                'carbs': 0.0,
                'fat': 0.0,
              };
            }

            aggregatedData[dateKey]!['calories'] =
                (aggregatedData[dateKey]!['calories'] ?? 0.0) + (data['calories'] ?? 0).toDouble();
            aggregatedData[dateKey]!['protein'] =
                (aggregatedData[dateKey]!['protein'] ?? 0.0) + (data['protein'] ?? 0).toDouble();
            aggregatedData[dateKey]!['carbs'] =
                (aggregatedData[dateKey]!['carbs'] ?? 0.0) + (data['carbs'] ?? 0).toDouble();
            aggregatedData[dateKey]!['fat'] =
                (aggregatedData[dateKey]!['fat'] ?? 0.0) + (data['fat'] ?? 0).toDouble();
          }

          final dates = aggregatedData.keys.toList()..sort();
          final labels = dates.map((d) {
            final date = DateTime.parse(d);
            return DateFormat('MM/dd').format(date);
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: BarChart(
              BarChartData(
                maxY: _getMaxY(aggregatedData),
                barGroups: _buildBarGroups(aggregatedData, dates),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()} kcal',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < labels.length) {
                          return Text(
                            labels[index],
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                barTouchData: BarTouchData(enabled: true),
              ),
            ),
          );
        },
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups(
      Map<String, Map<String, double>> aggregatedData, List<String> dates) {
    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < dates.length; i++) {
      final values = aggregatedData[dates[i]]!;
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: (values['calories'] ?? 0.0),
              color: Colors.greenAccent,
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }
    return barGroups;
  }

  double _getMaxY(Map<String, Map<String, double>> aggregatedData) {
    double maxY = 0;
    for (var values in aggregatedData.values) {
      if ((values['calories'] ?? 0.0) > maxY) {
        maxY = (values['calories'] ?? 0.0);
      }
    }
    return maxY + 100; // add extra space on top
  }
}
