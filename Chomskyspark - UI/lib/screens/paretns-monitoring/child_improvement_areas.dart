import 'package:flutter/material.dart';
import 'package:shop/models/child_improvement_area.dart';
import 'package:shop/providers/statistics_provider.dart';

class ChildImprovementAreasPage extends StatefulWidget {
  final int userId;

  ChildImprovementAreasPage({required this.userId});

  @override
  _ChildImprovementAreasPageState createState() => _ChildImprovementAreasPageState();
}

class _ChildImprovementAreasPageState extends State<ChildImprovementAreasPage> {
  List<ChildImprovementArea>? _wordsStatistics;
  bool _isLoading = true;
  String? _error;
  final statisticsProvider = StatisticsProvider();

  @override
  void initState() {
    super.initState();
    _fetchWordsStatistics();
  }

  Future<void> _fetchWordsStatistics() async {
    try {
      final stats = await statisticsProvider.fetchImprovementAreas(widget.userId);
      print(stats);
      setState(() {
        _wordsStatistics = stats;
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
          color: const Color(0xFF6A0DAD), // Page background color
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white), // Icon color
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Improvement Areas',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Text color
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
                        : _wordsStatistics != null && _wordsStatistics!.isNotEmpty
                            ? ListView.builder(
                                itemCount: _wordsStatistics!.length,
                                itemBuilder: (context, index) {
                                  final stat = _wordsStatistics![index];
                                  return Card(
                                    margin: const EdgeInsets.all(10),
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
                                          Text(stat.targetWord,
                                              style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold)),
                                          const Divider(),
                                          _buildStatisticRow(
                                              'Total Failed Attempts',
                                              '${stat.totalFailedAttempts}'),
                                          const Divider(),
                                          _buildStatisticRow(
                                              'Failed Percentage',
                                              '${stat.failedPercentage.round()} %'),
                                          LinearProgressIndicator(
                                            value: stat.failedPercentage.toDouble() / 100,
                                            backgroundColor: Colors.grey.shade300,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(Colors.blue),
                                            minHeight: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const Center(
                                child: Text('No data available.',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                              ),
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
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
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
