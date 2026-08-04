class TeacherModel {
  final String teacherId;
  final String userId;
  final String firstName;
  final String lastName;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? phone;
  final String? email;
  final String? address;
  final String? photo;
  final String? position;
  final String? qualification;
  final DateTime? hireDate;
  final double? salary;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TeacherModel({
    required this.teacherId,
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.gender,
    this.dateOfBirth,
    this.phone,
    this.email,
    this.address,
    this.photo,
    this.position,
    this.qualification,
    this.hireDate,
    this.salary,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  // Helper getter for full name in UI
  String get fullName => '$firstName $lastName';

  // Convert JSON response from Spring Boot into Dart object
  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      teacherId: json['teacher_id'] ?? json['teacherId'] ?? '',
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
      position: json['position'],
      qualification: json['qualification'],
      hireDate: json['hire_date'] != null
          ? DateTime.tryParse(json['hire_date'].toString())
          : (json['hireDate'] != null
          ? DateTime.tryParse(json['hireDate'].toString())
          : null),
      salary: json['salary'] != null
          ? double.tryParse(json['salary'].toString())
          : null,
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
      'teacher_id': teacherId,
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender,
      'date_of_birth': dateOfBirth?.toIso8601String().split('T')[0],
      'phone': phone,
      'email': email,
      'address': address,
      'photo': photo,
      'position': position,
      'qualification': qualification,
      'hire_date': hireDate?.toIso8601String().split('T')[0],
      'salary': salary,
      'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  // Helper method to create a modified copy of TeacherModel
  TeacherModel copyWith({
    String? teacherId,
    String? userId,
    String? firstName,
    String? lastName,
    String? gender,
    DateTime? dateOfBirth,
    String? phone,
    String? email,
    String? address,
    String? photo,
    String? position,
    String? qualification,
    DateTime? hireDate,
    double? salary,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TeacherModel(
      teacherId: teacherId ?? this.teacherId,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      photo: photo ?? this.photo,
      position: position ?? this.position,
      qualification: qualification ?? this.qualification,
      hireDate: hireDate ?? this.hireDate,
      salary: salary ?? this.salary,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}