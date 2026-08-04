class UserModel {
  final String userId;
  final String email;
  final String role; // 'ADMIN', 'TEACHER', or 'STUDENT'
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.userId,
    required this.email,
    required this.role,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  // Convert JSON response from Spring Boot into Dart object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] ?? json['userId'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'STUDENT',
      isActive: json['is_active'] ?? json['isActive'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : (json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : (json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null),
    );
  }

  // Convert Dart object to JSON payload to send to Spring Boot
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'role': role,
      'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  // Helper method to create a modified copy of UserModel
  UserModel copyWith({
    String? userId,
    String? email,
    String? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}