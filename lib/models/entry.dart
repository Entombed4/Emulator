class Entry {
  final String id;
  final String title;
  final String text;
  final DateTime date;
  final List<String> tags;
  final String? imagePath;

  const Entry({
    required this.id,
    required this.title,
    required this.text,
    required this.date,
    this.tags = const [],
    this.imagePath,
  });

  Entry copyWith({
    String? title,
    String? text,
    DateTime? date,
    List<String>? tags,
    String? imagePath,
  }) {
    return Entry(
      id: id,
      title: title ?? this.title,
      text: text ?? this.text,
      date: date ?? this.date,
      tags: tags ?? this.tags,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'text': text,
    'date': date.toIso8601String(),
    'tags': tags,
    'imagePath': imagePath,
  };

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
    id: json['id'] as String,
    title: json['title'] as String,
    text: (json['text'] as String?) ?? '',
    date: DateTime.parse(json['date'] as String),
    tags: List<String>.from(json['tags'] ?? const []),
    imagePath: json['imagePath'] as String?,
  );
}