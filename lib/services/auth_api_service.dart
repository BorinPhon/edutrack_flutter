import 'package:dio/dio.dart';

import '../models/login/login_request.dart';
import '../models/login/login_response.dart';
import 'api_service.dart';

class AuthApiService {
  final Dio _dio = ApiService().client;

  /*Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/oauth/token',
        data: request.toJson(),
      );

      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Unable to login. Please try again.",
      );
    }
  }*/
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/oauth/token',
        data: request.toJson(),
      );

      print("========== LOGIN RESPONSE ==========");
      print(response.data);
      print(response.data.runtimeType);
      print("===================================");

      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      print("========== DIO ERROR ==========");
      print(e.response?.data);
      print(e.response?.data.runtimeType);
      print("==============================");

      rethrow;
    }
  }
}