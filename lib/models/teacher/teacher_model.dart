class TeacherModel {
  final int id;
  final int userId;

  final String username;
  final String? email;

  final String firstName;
  final String lastName;

  final String? gender;
  final DateTime? dateOfBirth;

  final String? phone;
  final String? address;
  final String? photo;

  final bool isActive;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  TeacherModel({
    required this.id,
    required this.userId,
    required this.username,
    this.email,
    required this.firstName,
    required this.lastName,
    this.gender,
    this.dateOfBirth,
    this.phone,
    this.address,
    this.photo,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  String get fullName => "$firstName $lastName";

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json["id"] ?? 0,
      userId: json["userId"] ?? 0,
      username: json["username"] ?? "",
      email: json["email"],
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      gender: json["gender"],
      dateOfBirth: json["dateOfBirth"] != null
          ? DateTime.tryParse(json["dateOfBirth"])
          : null,
      phone: json["phone"],
      address: json["address"],
      photo: json["photo"],
      isActive: json["isActive"] ?? false,
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"])
          : null,
      updatedAt: json["updatedAt"] != null
          ? DateTime.tryParse(json["updatedAt"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "username": username,
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "gender": gender,
      "dateOfBirth": dateOfBirth?.toIso8601String().split("T").first,
      "phone": phone,
      "address": address,
      "photo": photo,
      "isActive": isActive,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }

  TeacherModel copyWith({
    int? id,
    int? userId,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? gender,
    DateTime? dateOfBirth,
    String? phone,
    String? address,
    String? photo,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TeacherModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      photo: photo ?? this.photo,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}