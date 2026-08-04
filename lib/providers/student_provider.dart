import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../services/student_api_service.dart';

class StudentProvider extends ChangeNotifier {
  // Instantiating the Dio HTTP API service
  final StudentApiService _apiService = StudentApiService();

  List<StudentModel> _students = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters exposed to UI screens
  List<StudentModel> get students => _students;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ---------------------------------------------------------------------------
  // 1. READ: Fetch all students from Spring Boot (GET /api/students)
  // ---------------------------------------------------------------------------
  Future<void> fetchStudents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Calls ApiService -> Dio HTTP GET -> Spring Boot Controller -> PostgreSQL
      _students = await _apiService.getAllStudents();
    } catch (e) {
      _errorMessage = 'Failed to load students. Please check your backend connection.';
      debugPrint('StudentProvider fetch error: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); // Updates UI List view
    }
  }

  // ---------------------------------------------------------------------------
  // 2. CREATE: Add new student to Spring Boot (POST /api/students)
  // ---------------------------------------------------------------------------
  Future<bool> addStudent(StudentModel student) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Dio sends JSON body to Spring Boot, which returns created entity with DB generated ID
      final createdStudent = await _apiService.createStudent(student);

      // Update local memory list
      _students.add(createdStudent);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Could not create student record.';
      debugPrint('StudentProvider add error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // 3. UPDATE: Modify student in Spring Boot (PUT /api/students/{id})
  // ---------------------------------------------------------------------------
  Future<bool> updateStudent(StudentModel updatedStudent) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.updateStudent(
        updatedStudent.studentId,
        updatedStudent,
      );

      // Locate target student in list and swap with fresh server response
      final index = _students.indexWhere((s) => s.studentId == result.studentId);
      if (index != -1) {
        _students[index] = result;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Could not update student details.';
      debugPrint('StudentProvider update error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // 4. DELETE: Remove student from Spring Boot (DELETE /api/students/{id})
  // ---------------------------------------------------------------------------
  Future<bool> deleteStudent(String studentId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.deleteStudent(studentId);

      // Remove item locally upon HTTP 200/204 response
      _students.removeWhere((s) => s.studentId == studentId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Could not delete student.';
      debugPrint('StudentProvider delete error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}