class ChildImprovementArea {
  final String targetWord;
  final int totalFailedAttempts;
  final double failedPercentage;

  ChildImprovementArea({
    required this.targetWord,
    required this.totalFailedAttempts,
    required this.failedPercentage,
  });

  factory ChildImprovementArea.fromJson(Map<String, dynamic> json) {
    return ChildImprovementArea(
      targetWord: json['targetWord'] as String,
      totalFailedAttempts: json['totalFailedAttempts'] as int,
      failedPercentage: (json['failedPercentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'targetWord': targetWord,
      'totalFailedAttempts': totalFailedAttempts,
      'failedPercentage': failedPercentage,
    };
  }
}
