import 'package:dio/dio.dart';
import '../models/teacher_model.dart';
import 'api_service.dart';

class TeacherApiService {
  final ApiService _apiService = ApiService();

  // ---------------------------------------------------------------------------
  // 1. GET /api/teachers - Retrieve all teachers
  // ---------------------------------------------------------------------------
  Future<List<TeacherModel>> getAllTeachers() async {
    try {
      final response = await _apiService.client.get('/teachers');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => TeacherModel.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Dio error fetching teachers: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching teachers: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // 2. GET /api/teachers/{id} - Retrieve single teacher by ID
  // ---------------------------------------------------------------------------
  Future<TeacherModel?> getTeacherById(String teacherId) async {
    try {
      final response = await _apiService.client.get('/teachers/$teacherId');

      if (response.statusCode == 200) {
        return TeacherModel.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      throw Exception('Dio error fetching teacher details: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // 3. POST /api/teachers - Create new teacher record
  // ---------------------------------------------------------------------------
  Future<TeacherModel> createTeacher(TeacherModel teacher) async {
    try {
      final response = await _apiService.client.post(
        '/teachers',
        data: teacher.toJson(),
      );

      return TeacherModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Dio error creating teacher: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Unexpected error creating teacher: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // 4. PUT /api/teachers/{id} - Update existing teacher record
  // ---------------------------------------------------------------------------
  Future<TeacherModel> updateTeacher(String teacherId, TeacherModel teacher) async {
    try {
      final response = await _apiService.client.put(
        '/teachers/$teacherId',
        data: teacher.toJson(),
      );

      return TeacherModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Dio error updating teacher: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Unexpected error updating teacher: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // 5. DELETE /api/teachers/{id} - Delete teacher record
  // ---------------------------------------------------------------------------
  Future<void> deleteTeacher(String teacherId) async {
    try {
      await _apiService.client.delete('/teachers/$teacherId');
    } on DioException catch (e) {
      throw Exception('Dio error deleting teacher: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting teacher: $e');
    }
  }
}