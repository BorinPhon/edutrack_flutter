import 'package:flutter/foundation.dart'; // Add this line
import 'package:dio/dio.dart';
import 'package:dio/dio.dart';

class ApiService {
  late final Dio _dio;

  // Base URL configuration:
  // Use 'http://10.0.2.2:8080/api' for Android Emulator
  // Use 'http://localhost:8080/api' for iOS Simulator / Web / Desktop
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors for debugging and handling authorization tokens
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('HTTP Request: ${options.method} -> ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('HTTP Response: [${response.statusCode}] -> ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          debugPrint('HTTP Error: ${error.message} -> ${error.response?.statusCode}');
          return handler.next(error);
        },
      ),
    );
  }

  Dio get client => _dio;
}