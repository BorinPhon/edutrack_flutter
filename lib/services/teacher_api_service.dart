import 'package:dio/dio.dart';

import '../models/teacher/teacher_model.dart';
import '../models/teacher/teacher_request.dart';
import 'api_service.dart';

class TeacherApiService {
  final ApiService _apiService = ApiService();

  // ===============================
  // GET ALL TEACHERS
  // ===============================
  Future<List<TeacherModel>> getAllTeachers() async {
    try {
      final response = await _apiService.client.get('/teachers');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        return data
            .map((json) => TeacherModel.fromJson(json))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? e.message);
    }
  }

  // ===============================
  // GET TEACHER BY ID
  // ===============================
  Future<TeacherModel> getTeacherById(int id) async {
    try {
      final response = await _apiService.client.get('/teachers/$id');

      return TeacherModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? e.message);
    }
  }

  // ===============================
  // CREATE TEACHER
  // ===============================
  Future<TeacherModel> createTeacher(
      TeacherRequest request,
      ) async {
    try {
      final response = await _apiService.client.post(
        '/teachers',
        data: request.toJson(),
      );

      return TeacherModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? e.message);
    }
  }

  // ===============================
  // UPDATE TEACHER
  // ===============================
  Future<TeacherModel> updateTeacher(
      int id,
      TeacherRequest request,
      ) async {
    try {
      final response = await _apiService.client.put(
        '/teachers/$id',
        data: request.toJson(),
      );

      return TeacherModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? e.message);
    }
  }

  // ===============================
  // DELETE TEACHER
  // ===============================
  Future<void> deleteTeacher(int id) async {
    try {
      await _apiService.client.delete('/teachers/$id');
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? e.message);
    }
  }
}