class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String role; // 'admin', 'staff'
  final String createdAt;
  final String? imagePath;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.createdAt,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'created_at': createdAt,
      'image_path': imagePath,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
      createdAt: map['created_at'],
      imagePath: map['image_path'],
    );
  }
}
