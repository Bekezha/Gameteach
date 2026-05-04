class ProfileModel {
  final String name;
  final String email;
  final String role;
  final int answeredQuestions;
  final int gamesPlayed;
  final int points;

  ProfileModel({
    required this.name,
    required this.email,
    this.role = 'student',
    this.answeredQuestions = 0,
    this.gamesPlayed = 0,
    this.points = 0,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'] ?? json['user']?['name'] ?? '',
      email: json['email'] ?? json['user']?['email'] ?? '',
      role: json['role'] ?? json['user']?['role'] ?? 'student',
      answeredQuestions: json['answeredQuestions'] ?? json['user']?['answeredQuestions'] ?? 0,
      gamesPlayed: json['gamesPlayed'] ?? json['user']?['gamesPlayed'] ?? 0,
      points: json['points'] ?? json['user']?['points'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'answeredQuestions': answeredQuestions,
      'gamesPlayed': gamesPlayed,
      'points': points,
    };
  }
}
