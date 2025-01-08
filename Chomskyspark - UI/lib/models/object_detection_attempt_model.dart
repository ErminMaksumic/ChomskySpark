class ObjectDetectionAttempt {
  final int? id;
  final int? userId;
  final String targetWord; // The word the user needs to find
  final String selectedWord; // The word the user selected
  final bool success; // Whether the attempt was successful
  final int attemptNumber; // The number of the attempt
  final int elapsedTimeInSeconds; // Elapsed time in seconds
  final DateTime timestamp; // When the attempt occurred

  ObjectDetectionAttempt({
    this.id = 0,
    this.userId,
    required this.targetWord,
    required this.selectedWord,
    required this.success,
    required this.attemptNumber,
    required this.elapsedTimeInSeconds,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'targetWord': targetWord,
      'selectedWord': selectedWord,
      'success': success,
      'attemptNumber': attemptNumber,
      'elapsedTimeInSeconds': elapsedTimeInSeconds,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ObjectDetectionAttempt.fromJson(Map<String, dynamic> json) {
    return ObjectDetectionAttempt(
      id: json['id'],
      userId: json['userId'],
      targetWord: json['targetWord'],
      selectedWord: json['selectedWord'],
      success: json['success'],
      attemptNumber: json['attemptNumber'],
      elapsedTimeInSeconds: json['elapsedTimeInSeconds'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
