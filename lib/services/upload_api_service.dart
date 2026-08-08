import 'dart:io';

import 'package:dio/dio.dart';

import 'api_service.dart';

class UploadApiService {

  final ApiService _apiService = ApiService();

  Future<String> uploadImage(
      File image,
      String folder,
      ) async {

    String fileName = image.path.split('/').last;

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        image.path,
        filename: fileName,
      ),
    });

    final response = await _apiService.client.post(
      "/app/upload/$folder",
      data: formData,
      options: Options(
        contentType: "multipart/form-data",
      ),
    );

    return response.data["fileName"];
  }
}