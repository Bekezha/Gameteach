class ProfileModel {
  final String name;
  final String email;

  ProfileModel({required this.name, required this.email});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'] ?? json['user']?['name'] ?? '',
      email: json['email'] ?? json['user']?['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email};
  }
}
