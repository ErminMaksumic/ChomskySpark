class DailyStatistic {
  final DateTime date;
  final int totalAttempts;
  final int successfulAttempts;
  final double successRate;

  DailyStatistic({
    required this.date,
    required this.totalAttempts,
    required this.successfulAttempts,
    required this.successRate,
  });

  factory DailyStatistic.fromJson(Map<String, dynamic> json) {
    return DailyStatistic(
      date: DateTime.parse(json['date']),
      totalAttempts: json['totalAttempts'],
      successfulAttempts: json['successfulAttempts'],
      successRate: json['successRate'].toDouble(),
    );
  }
}