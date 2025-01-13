class ChildAverageTime {
  final int userId;
  final double averageTimeInSeconds;

  ChildAverageTime({
    required this.userId,
    required this.averageTimeInSeconds,
  });

  factory ChildAverageTime.fromJson(Map<String, dynamic> json) {
    return ChildAverageTime(
      userId: json['userId'] ?? 0,
      averageTimeInSeconds: json['averageTimeInSeconds']?.toDouble() ?? 0.0,
    );
  }
}
