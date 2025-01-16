class WordForImage {
  int id;
  String name;
  int userId;

  WordForImage({
    required this.id,
    required this.name,
    required this.userId,
  });

  factory WordForImage.fromJson(Map<String, dynamic> json) {
    return WordForImage(
      id: json['id'],
      name: json['name'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
    };
  }
}
