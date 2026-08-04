import 'package:dio/dio.dart';
import '../models/student_model.dart';
import 'api_service.dart';

class StudentApiService {
  final ApiService _apiService = ApiService();

  // GET /api/students
  Future<List<StudentModel>> getAllStudents() async {
    try {
      final response = await _apiService.client.get('/students');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => StudentModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load students: $e');
    }
  }

  // POST /api/students
  Future<StudentModel> createStudent(StudentModel student) async {
    try {
      final response = await _apiService.client.post(
        '/students',
        data: student.toJson(),
      );

      return StudentModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create student: $e');
    }
  }

  // PUT /api/students/{id}
  Future<StudentModel> updateStudent(String id, StudentModel student) async {
    try {
      final response = await _apiService.client.put(
        '/students/$id',
        data: student.toJson(),
      );

      return StudentModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update student: $e');
    }
  }

  // DELETE /api/students/{id}
  Future<void> deleteStudent(String id) async {
    try {
      await _apiService.client.delete('/students/$id');
    } catch (e) {
      throw Exception('Failed to delete student: $e');
    }
  }
}