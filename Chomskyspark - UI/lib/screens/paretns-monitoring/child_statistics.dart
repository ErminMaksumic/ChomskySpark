import 'package:flutter/material.dart';
import 'package:shop/models/user_statistics.dart';

import 'package:shop/providers/statistics_provider.dart';

class ChildStatisticsPage extends StatefulWidget {
  final int userId;

  ChildStatisticsPage({required this.userId});

  @override
  _ChildStatisticsPageState createState() => _ChildStatisticsPageState();
}

class _ChildStatisticsPageState extends State<ChildStatisticsPage> {
  UserStatistics? _userStatistics;
  bool _isLoading = true;
  String? _error;
  final statisticsProvider = StatisticsProvider();

  @override
  void initState() {
    super.initState();
    _fetchStatistics();
  }

  Future<void> _fetchStatistics() async {
    try {
      final stats = await statisticsProvider.fetchUserStatistics(widget.userId);
      setState(() {
        _userStatistics = stats;
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Child Statistic',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 48), // For symmetry
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : _error != null
                    ? Center(
                  child: Text(
                    'Error: $_error',
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                )
                    : _userStatistics != null
                    ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.blueAccent,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildStatisticRow('Child', 'John Smith'),
                          const Divider(),
                          _buildStatisticRow('Total Attempts', '${_userStatistics!.totalAttempts}'),
                          const Divider(),
                          _buildStatisticRow('Successful Attempts', '${_userStatistics!.successfulAttempts}'),
                          const Divider(),
                          _buildStatisticRow(
                              'Avg Elapsed Time', '${_userStatistics!.averageElapsedTime.toStringAsFixed(2)} seconds'),
                        ],
                      ),
                    ),
                  ),
                )
                    : const Center(child: Text('No data available.', style: TextStyle(color: Colors.white, fontSize: 18))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
