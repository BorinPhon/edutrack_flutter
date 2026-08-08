import 'package:dio/dio.dart';

import '../models/student/student_model.dart';
import '../models/student/student_request.dart';
import 'api_service.dart';

class StudentApiService {
  final ApiService _apiService = ApiService();

  //------------------------------------------------------------
  // GET ALL STUDENTS
  //------------------------------------------------------------

  Future<List<StudentModel>> getAllStudents() async {
    try {
      final response = await _apiService.client.get('/students');

      final List data = response.data;

      return data
          .map((e) => StudentModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to load students.",
      );
    }
  }

  //------------------------------------------------------------
  // GET STUDENT BY ID
  //------------------------------------------------------------

  Future<StudentModel> getStudentById(int id) async {
    try {
      final response =
      await _apiService.client.get('/students/$id');

      return StudentModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to load student.",
      );
    }
  }

  //------------------------------------------------------------
  // CREATE STUDENT
  //------------------------------------------------------------

  Future<StudentModel> createStudent(
      StudentRequest request) async {
    try {
      final response = await _apiService.client.post(
        '/students',
        data: request.toJson(),
      );

      return StudentModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to create student.",
      );
    }
  }

  //------------------------------------------------------------
  // UPDATE STUDENT
  //------------------------------------------------------------

  Future<StudentModel> updateStudent(
      int id,
      StudentRequest request) async {
    print("===== UPDATE STUDENT =====");
    print(request.toJson());
    try {
      final response = await _apiService.client.put(
        '/students/$id',
        data: request.toJson(),
      );

      return StudentModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to update student.",
      );
    }
  }

  //------------------------------------------------------------
  // DELETE STUDENT
  //------------------------------------------------------------

  Future<void> deleteStudent(int id) async {
    try {
      await _apiService.client.delete(
        '/students/$id',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to delete student.",
      );
    }
  }
}