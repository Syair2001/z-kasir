class UserModel {
  final int id;
  final String name;
  final String username;
  final String? phoneNumber;
  final String? email;
  final String role;
  final bool isApproved;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    this.phoneNumber,
    this.email,
    required this.role,
    required this.isApproved,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      phoneNumber: json['phone_number'],
      email: json['email'],
      role: json['role'] ?? 'mustahik',
      isApproved: json['is_approved'] ?? false,
    );
  }
}