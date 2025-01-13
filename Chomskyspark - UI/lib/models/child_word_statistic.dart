class ChildWordStatistic {
  final String targetWord;
  final int totalAttempts;
  final int successfulAttempts;
  final double averageElapsedTime;
  final double successRate;

  ChildWordStatistic({
    required this.targetWord,
    required this.totalAttempts,
    required this.successfulAttempts,
    required this.averageElapsedTime,
    required this.successRate,
  });

  factory ChildWordStatistic.fromJson(Map<String, dynamic> json) {
    return ChildWordStatistic(
      targetWord: json['targetWord'] ?? '',
      totalAttempts: json['totalAttempts'] ?? 0,
      successfulAttempts: json['successfulAttempts'] ?? 0,
      averageElapsedTime: json['averageElapsedTime']?.toDouble() ?? 0.0,
      successRate: json['successRate']?.toDouble() ?? 0.0,
    );
  }
}
