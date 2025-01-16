import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/models/child_word_statistic.dart';
import 'package:shop/providers/statistics_provider.dart';

class ChildWordsStatisticsPage extends StatefulWidget {
  final int userId;

  ChildWordsStatisticsPage({required this.userId});

  @override
  _ChildWordsStatisticsPageState createState() =>
      _ChildWordsStatisticsPageState();
}

class _ChildWordsStatisticsPageState extends State<ChildWordsStatisticsPage> {
  List<ChildWordStatistic>? _wordsStatistics;
  bool _isLoading = true;
  String? _error;
  final wordsStatisticsProvider = StatisticsProvider();
  TextEditingController _wordController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWordsStatistics();
  }

  Future<void> _fetchWordsStatistics(
      {String? word, DateTime? startDate, DateTime? endDate}) async {
    try {
      final stats = await wordsStatisticsProvider.fetchWordsStatistics(
        widget.userId,
        word,
        startDate,
        endDate,
      );
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
      appBar: AppBar(
        title: Text(
          'Word Statistics',
          style: TextStyle(color: Colors.black), // Black text in AppBar
        ),
        backgroundColor: Colors.white, // White background for AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Black back icon
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Color(0xFF6A0DAD), // Purple background for the page
        child: SafeArea(
          child: Column(
            children: [
              _buildFilterSection(),
              Expanded(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator(color: Colors.white))
                    : _error != null
                        ? Center(
                            child: Text(
                              'Error: $_error',
                              style: TextStyle(color: Colors.red, fontSize: 18),
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
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold)),
                                          Divider(),
                                          _buildStatisticRow('Total Attempts', '${stat.totalAttempts}'),
                                          Divider(),
                                          _buildStatisticRow('Successful Attempts', '${stat.successfulAttempts}'),
                                          Divider(),
                                          _buildStatisticRow('Average Elapsed Time', '${stat.averageElapsedTime.toStringAsFixed(2)} seconds'),
                                          Divider(),
                                          _buildStatisticRow('Success Rate', '${stat.successRate.toStringAsFixed(2)}%'),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                  'No data available.',
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return ExpansionTile(
      title: Text("Show Filters", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      initiallyExpanded: false,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _wordController,
                decoration: InputDecoration(
                  labelText: 'Target Word',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _startDateController,
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onTap: () => _selectDate(context, _startDateController),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _endDateController,
                decoration: InputDecoration(
                  labelText: 'End Date',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onTap: () => _selectDate(context, _endDateController),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _fetchWordsStatistics(
                    word: _wordController.text,
                    startDate: _startDateController.text.isEmpty
                        ? null
                        : DateFormat('yyyy-MM-dd').parse(_startDateController.text),
                    endDate: _endDateController.text.isEmpty
                        ? null
                        : DateFormat('yyyy-MM-dd').parse(_endDateController.text),
                  );
                },
                child: Text('Apply Filters'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6A0DAD), // Purple button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
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
