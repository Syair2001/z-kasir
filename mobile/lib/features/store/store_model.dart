class StoreModel {
  final int id;
  final String name;
  final String address;
  final String? phone;
  final String logo;
  final bool hasCustomLogo;
  final bool isActive;
  final String createdAt;

  StoreModel({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
    required this.logo,
    required this.hasCustomLogo,
    required this.isActive,
    required this.createdAt,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      logo: json['logo'] ?? '',
      hasCustomLogo: json['has_custom_logo'] ?? false,
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }
}