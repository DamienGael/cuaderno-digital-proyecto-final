class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final int totalPoints;
  final int level;
  final List<String> badges;
  final String? photoUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.totalPoints,
    required this.level,
    required this.badges,
    this.photoUrl,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'alumno',
      totalPoints: map['totalPoints'] ?? 0,
      level: map['level'] ?? 1,
      badges: List<String>.from(map['badges'] ?? []),
      photoUrl: map['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'totalPoints': totalPoints,
      'level': level,
      'badges': badges,
      'photoUrl': photoUrl,
    };
  }
}
