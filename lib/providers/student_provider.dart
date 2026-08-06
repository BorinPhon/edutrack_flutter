import 'package:flutter/material.dart';

import '../models/student/student_model.dart';
import '../models/student/student_request.dart';
import '../services/student_api_service.dart';

class StudentProvider extends ChangeNotifier {
  final StudentApiService _apiService = StudentApiService();

  List<StudentModel> _students = [];

  bool _isLoading = false;

  String? _errorMessage;

  List<StudentModel> get students => _students;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  //------------------------------------------------------------
  // GET ALL
  //------------------------------------------------------------

  Future<void> fetchStudents() async {
    try {
      _isLoading = true;
      _errorMessage = null;

      notifyListeners();

      _students = await _apiService.getAllStudents();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //------------------------------------------------------------
  // GET BY ID
  //------------------------------------------------------------

  Future<StudentModel?> getStudentById(int id) async {
    try {
      return await _apiService.getStudentById(id);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  //------------------------------------------------------------
  // CREATE
  //------------------------------------------------------------

  Future<bool> addStudent(
      StudentRequest request,
      ) async {
    try {
      _isLoading = true;

      notifyListeners();

      await _apiService.createStudent(request);

      await fetchStudents();

      return true;
    } catch (e) {
      _errorMessage = e.toString();

      notifyListeners();

      return false;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  //------------------------------------------------------------
  // UPDATE
  //------------------------------------------------------------

  Future<bool> updateStudent(
      int id,
      StudentRequest request,
      ) async {
    try {
      _isLoading = true;

      notifyListeners();

      await _apiService.updateStudent(
        id,
        request,
      );

      await fetchStudents();

      return true;
    } catch (e) {
      _errorMessage = e.toString();

      notifyListeners();

      return false;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  //------------------------------------------------------------
  // DELETE
  //------------------------------------------------------------

  Future<bool> deleteStudent(int id) async {
    try {
      _isLoading = true;

      notifyListeners();

      await _apiService.deleteStudent(id);

      _students.removeWhere(
            (student) => student.id == id,
      );

      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();

      notifyListeners();

      return false;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }
}