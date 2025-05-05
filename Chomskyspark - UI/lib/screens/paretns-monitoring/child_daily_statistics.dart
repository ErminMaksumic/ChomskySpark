import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:chomskyspark/models/daily_statistic.dart';
import 'package:chomskyspark/providers/statistics_provider.dart';

class ChildDailyStatistics extends StatefulWidget {
  final int userId;

  ChildDailyStatistics({required this.userId});

  @override
  _ChildDailyStatisticsState createState() => _ChildDailyStatisticsState();
}

class _ChildDailyStatisticsState extends State<ChildDailyStatistics> {
  late List<DailyStatistic> data = [];
  bool _isLoading = true;
  String? _error;
  final statisticsProvider = StatisticsProvider();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final response = await statisticsProvider.fetchDailyStatistics(widget.userId);
      print(response);
      setState(() {
        data = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Child Daily Statistic'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Success Rate Over Time',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: data.isEmpty ? const Center(
                    child: Text(
                      'No data available.',
                      style: TextStyle(color: Colors.purple, fontSize: 18),
                    ),
                  ) : Padding(
                    padding: const EdgeInsets.all(12),
                    child: BarChart(
                      BarChartData(
                        barGroups: data
                            .map(
                              (e) => BarChartGroupData(
                                x: int.parse(e.date.toString().split("-")[2].split(" ")[0]),
                                barRods: [
                                  BarChartRodData(
                                    toY: e.successRate.toDouble(),
                                    gradient: LinearGradient(
                                      colors: [Colors.purple, Colors.deepPurple],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    width: 18,
                                    borderRadius: BorderRadius.all(Radius.circular(6)),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                final date = data[value.toInt() % data.length]
                                        .date
                                        .toString()
                                        .split('-')[2] +
                                    " Jan";
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    date,
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return Text(
                                  '${value.toInt()}%',
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                );
                              },
                              interval: 25,
                            ),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          horizontalInterval: 25,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.white24,
                              strokeWidth: 1.0,
                            );
                          },
                        ),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Success Rates (%) by Dates last 7 days',
                        style: TextStyle(color: Colors.purple, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
