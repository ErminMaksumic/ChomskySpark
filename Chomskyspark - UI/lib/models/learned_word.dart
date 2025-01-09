class LearnedWord {
  final int? id;
  final int userId;
  final String word;
  final DateTime dateTime;

  LearnedWord({
    this.id = 0,
    required this.userId,
    this.word = '',
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'word': word,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory LearnedWord.fromJson(Map<String, dynamic> json) {
    return LearnedWord(
      id: json['id'],
      userId: json['userId'],
      word: json['word'] ?? '',
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
}
