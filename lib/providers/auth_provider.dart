import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../Utils/token_storage.dart';
import '../models/Login/change_password_request.dart';
import '../models/login/login_request.dart';
import '../models/login/login_response.dart';
import '../services/auth_api_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthApiService _authApiService = AuthApiService();
  final TokenStorage _tokenStorage = TokenStorage();

  bool _isLoading = false;
  String? _errorMessage;
  LoginResponse? _loginResponse;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LoginResponse? get loginResponse => _loginResponse;

  //------------------------------------------
  // LOGIN
  //------------------------------------------

  Future<bool> login({
    required String phoneNumber,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = LoginRequest(
        phoneNumber: phoneNumber,
        password: password,
      );

      final response = await _authApiService.login(request);

      _loginResponse = response;

      await _tokenStorage.saveAccessToken(response.accessToken);
      await _tokenStorage.saveRefreshToken(response.refreshToken);

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      if (e is DioException) {
        switch (e.response?.statusCode) {
          case 400:
            _errorMessage = "Invalid request.";
            break;

          case 401:
            _errorMessage = "Invalid username or password.";
            break;

          case 403:
            _errorMessage = "Access denied.";
            break;

          case 404:
            _errorMessage = "Service not found.";
            break;

          case 500:
            _errorMessage = "Internal server error.";
            break;

          default:
            if (e.type == DioExceptionType.connectionTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.sendTimeout) {
              _errorMessage = "Connection timeout.";
            } else if (e.type == DioExceptionType.connectionError) {
              _errorMessage = "Unable to connect to server.";
            } else {
              _errorMessage = "Login failed.";
            }
        }
      } else {
        _errorMessage = "Invalid username or password.";
      }

      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  //------------------------------------------
  // CHANGE PASSWORD
  //------------------------------------------

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = ChangePasswordRequest(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      await _authApiService.changePassword(request);

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      if (e is DioException) {
        _errorMessage =
            e.response?.data["message"] ?? "Unable to change password.";
      } else {
        _errorMessage = e.toString();
      }

      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  //------------------------------------------
  // LOGOUT
  //------------------------------------------

  Future<void> logout() async {
    await _tokenStorage.clear();

    _loginResponse = null;
    _errorMessage = null;

    notifyListeners();
  }
}