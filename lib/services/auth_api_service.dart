import 'package:dio/dio.dart';

import '../models/Login/change_password_request.dart';
import '../models/login/login_request.dart';
import '../models/login/login_response.dart';
import 'api_service.dart';

class AuthApiService {
  final Dio _dio = ApiService().client;

  //------------------------------------------
  // LOGIN
  //------------------------------------------

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/oauth/token',
        data: request.toJson(),
      );

      return LoginResponse.fromJson(response.data);

    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to login. Please try again.",
      );
    }
  }

  //------------------------------------------
  // CHANGE PASSWORD
  //------------------------------------------

  Future<String> changePassword(
      ChangePasswordRequest request) async {

    try {

      final response = await _dio.put(
        '/app/user/change-password',
        data: request.toJson(),
      );

      return response.data["message"];

    } on DioException catch (e) {

      throw Exception(
        e.response?.data["message"] ??
            "Unable to change password.",
      );

    }

  }
}