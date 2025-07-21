class TrainingSession {
  final int? id;
  final String date;
  final String? dojo;
  final int userId;
  final List<String> techniques;
  final List<String> types;
  final int duration; // duration in minutes

  TrainingSession({
    this.id,
    required this.date,
    this.dojo,
    required this.userId,
    this.techniques = const [],
    this.types = const [],
    required this.duration,
  });

  factory TrainingSession.fromJson(Map<String, dynamic> json) {
    return TrainingSession(
      id: json['id'],
      date: json['date'] ?? '',
      dojo: json['dojo'],
      userId: json['user_id'] ?? 0,
      techniques: json['techniques'] != null
          ? (json['techniques'] as String)
              .split(',')
              .where((t) => t.isNotEmpty)
              .toList()
          : [],
      types: json['types'] != null
          ? (json['types'] as String)
              .split(',')
              .where((t) => t.isNotEmpty)
              .toList()
          : [],
      duration: json['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'dojo': dojo,
      'user_id': userId,
      'techniques': techniques.join(','),
      'types': types.join(','),
      'duration': duration,
    };
  }

  TrainingSession copyWith({
    int? id,
    String? date,
    String? dojo,
    int? userId,
    List<String>? techniques,
    List<String>? types,
    int? duration,
  }) {
    return TrainingSession(
      id: id ?? this.id,
      date: date ?? this.date,
      dojo: dojo ?? this.dojo,
      userId: userId ?? this.userId,
      techniques: techniques ?? this.techniques,
      types: types ?? this.types,
      duration: duration ?? this.duration,
    );
  }
}
