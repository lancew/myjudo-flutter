class User {
  final int id;
  final String username;
  final String email;
  final String? dojo;
  final int sessions;
  final int sessionsThisMonth;
  final int sessionsLastMonth;
  final int sessionsThisYear;
  final int sessionsLastYear;
  final Map<String, int> sessionTypes;
  final Map<String, int> techniques;
  final Map<String, int> techniquesThisMonth;
  final Map<String, int> techniquesLastMonth;
  final Map<String, int> techniquesThisYear;
  final Map<String, int> techniquesLastYear;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.dojo,
    this.sessions = 0,
    this.sessionsThisMonth = 0,
    this.sessionsLastMonth = 0,
    this.sessionsThisYear = 0,
    this.sessionsLastYear = 0,
    this.sessionTypes = const {},
    this.techniques = const {},
    this.techniquesThisMonth = const {},
    this.techniquesLastMonth = const {},
    this.techniquesThisYear = const {},
    this.techniquesLastYear = const {},
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      dojo: json['dojo'],
      sessions: json['sessions'] ?? 0,
      sessionsThisMonth: json['sessions_this_month'] ?? 0,
      sessionsLastMonth: json['sessions_last_month'] ?? 0,
      sessionsThisYear: json['sessions_this_year'] ?? 0,
      sessionsLastYear: json['sessions_last_year'] ?? 0,
      sessionTypes: Map<String, int>.from(json['session_types'] ?? {}),
      techniques: Map<String, int>.from(json['techniques'] ?? {}),
      techniquesThisMonth:
          Map<String, int>.from(json['techniques_this_month'] ?? {}),
      techniquesLastMonth:
          Map<String, int>.from(json['techniques_last_month'] ?? {}),
      techniquesThisYear:
          Map<String, int>.from(json['techniques_this_year'] ?? {}),
      techniquesLastYear:
          Map<String, int>.from(json['techniques_last_year'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'dojo': dojo,
      'sessions': sessions,
      'sessions_this_month': sessionsThisMonth,
      'sessions_last_month': sessionsLastMonth,
      'sessions_this_year': sessionsThisYear,
      'sessions_last_year': sessionsLastYear,
      'session_types': sessionTypes,
      'techniques': techniques,
      'techniques_this_month': techniquesThisMonth,
      'techniques_last_month': techniquesLastMonth,
      'techniques_this_year': techniquesThisYear,
      'techniques_last_year': techniquesLastYear,
    };
  }
}
