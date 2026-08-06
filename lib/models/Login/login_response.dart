import 'user_model.dart';

class LoginResponse {
  final String accessToken;
  final String tokenType;
  final String refreshToken;
  final int expiresIn;
  final UserModel user;

  LoginResponse({
    required this.accessToken,
    required this.tokenType,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json["accessToken"],
      tokenType: json["tokenType"],
      refreshToken: json["refreshToken"],
      expiresIn: json["expiresIn"],
      user: UserModel.fromJson(json["user"]),
    );
  }
}