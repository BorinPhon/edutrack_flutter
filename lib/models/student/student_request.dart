class StudentRequest {
  final String email;
  final String firstName;
  final String lastName;
  final String gender;
  final DateTime dateOfBirth;
  final String phone;
  final String address;
  final String photo;

  const StudentRequest({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
    required this.phone,
    required this.address,
    required this.photo,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "gender": gender,
      "dateOfBirth": dateOfBirth.toIso8601String().split("T").first,
      "phone": phone,
      "address": address,
      "photo": photo,
    };
  }
}