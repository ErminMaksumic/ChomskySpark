class UserStatistics {
  final int totalAttempts;
  final int successfulAttempts;
  final double averageElapsedTime;

  UserStatistics({
    required this.totalAttempts,
    required this.successfulAttempts,
    required this.averageElapsedTime,
  });

  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    return UserStatistics(
      totalAttempts: json['totalAttempts'] ?? 0,
      successfulAttempts: json['successfulAttempts'] ?? 0,
      averageElapsedTime: json['averageElapsedTime']?.toDouble() ?? 0.0,
    );
  }
}
