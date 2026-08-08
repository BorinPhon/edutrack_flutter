import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../Utils/token_storage.dart';

class ApiService {
  late final Dio _dio;

  //static const String baseUrl = 'http://38.242.236.109:8090/api';
  static const String serverUrl = "http://192.168.0.108:30033";
  static const String baseUrl = "$serverUrl/api";
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

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final tokenStorage = TokenStorage();

          final token = await tokenStorage.getAccessToken();

          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          debugPrint(
              "REQUEST ${options.method} ${options.uri}");

          debugPrint("HEADERS : ${options.headers}");

          handler.next(options);
        },

        onResponse: (response, handler) {
          debugPrint(
              "RESPONSE ${response.statusCode} ${response.requestOptions.uri}");

          handler.next(response);
        },

        onError: (error, handler) {
          debugPrint(
              "ERROR ${error.response?.statusCode}");

          debugPrint(error.message);

          handler.next(error);
        },
      ),
    );
  }

  Dio get client => _dio;
}