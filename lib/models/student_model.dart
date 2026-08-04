class StudentModel {
  final String studentId;
  final String userId;
  final String firstName;
  final String lastName;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? phone;
  final String? email;
  final String? address;
  final String? photo;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StudentModel({
    required this.studentId,
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.gender,
    this.dateOfBirth,
    this.phone,
    this.email,
    this.address,
    this.photo,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  // Getter for convenience in UI display (e.g., 'John Doe')
  String get fullName => '$firstName $lastName';

  // Convert JSON response from Spring Boot into Dart object
  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      studentId: json['student_id'] ?? json['studentId'] ?? '',
      userId: json['user_id'] ?? json['userId'] ?? '',
      firstName: json['first_name'] ?? json['firstName'] ?? '',
      lastName: json['last_name'] ?? json['lastName'] ?? '',
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.tryParse(json['date_of_birth'].toString())
          : (json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'].toString())
          : null),
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      photo: json['photo'],
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
      'student_id': studentId,
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender,
      'date_of_birth': dateOfBirth?.toIso8601String().split('T')[0], // YYYY-MM-DD
      'phone': phone,
      'email': email,
      'address': address,
      'photo': photo,
      'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  // Helper method to create a modified copy of StudentModel
  StudentModel copyWith({
    String? studentId,
    String? userId,
    String? firstName,
    String? lastName,
    String? gender,
    DateTime? dateOfBirth,
    String? phone,
    String? email,
    String? address,
    String? photo,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StudentModel(
      studentId: studentId ?? this.studentId,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      photo: photo ?? this.photo,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}