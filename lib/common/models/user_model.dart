class User {
  final String id;
  final String name;
  final String role;
  final String token;

  User({
    required this.id,
    required this.name,
    required this.role,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      token: json['token'] ?? '',
    );
  }
}