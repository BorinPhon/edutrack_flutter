import 'package:flutter/material.dart';

import '../Utils/token_storage.dart';
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
      _errorMessage = e.toString();

      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  Future<void> logout() async {
    await _tokenStorage.clear();

    _loginResponse = null;
    _errorMessage = null;

    notifyListeners();
  }
}