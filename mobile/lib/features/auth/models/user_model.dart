class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String avatar;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.role = 'user',
    this.avatar = '',
  });

  // Chuyển đổi từ JSON (Backend trả về) sang UserModel Object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'user',
      avatar: json['avatar'] ?? '',
    );
  }

  // Chuyển đổi từ UserModel Object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'avatar': avatar,
    };
  }
}
