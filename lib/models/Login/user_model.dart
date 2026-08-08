import 'role_model.dart';

class UserModel {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String status;
  final String profile;
  final List<RoleModel> roles;

  UserModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.status,
    required this.roles,
    required this.profile
  });
  String get profileFolder {

    if (roles.any((r) => r.name == "ROLE_STUDENT")) {
      return "students";
    }

    if (roles.any((r) => r.name == "ROLE_TEACHER")) {
      return "teachers";
    }

    return "teachers"; // Admin
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      username: json["username"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      status: json["status"],
      profile: json["profile"],
      roles: (json["roles"] as List)
          .map((e) => RoleModel.fromJson(e))
          .toList(),
    );
  }
}