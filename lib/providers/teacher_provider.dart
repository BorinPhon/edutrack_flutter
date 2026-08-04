import 'package:flutter/material.dart';
import '../models/teacher_model.dart';
import '../services/teacher_api_service.dart';

class TeacherProvider extends ChangeNotifier {
  final TeacherApiService _apiService = TeacherApiService();

  List<TeacherModel> _teachers = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TeacherModel> get teachers => _teachers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 1. READ: GET /api/teachers
  Future<void> fetchTeachers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _teachers = await _apiService.getAllTeachers();
    } catch (e) {
      _errorMessage = 'Failed to load teachers.';
      debugPrint('TeacherProvider fetch error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. CREATE: POST /api/teachers
  Future<bool> addTeacher(TeacherModel teacher) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final createdTeacher = await _apiService.createTeacher(teacher);
      _teachers.add(createdTeacher);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Could not create teacher record.';
      debugPrint('TeacherProvider add error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 3. UPDATE: PUT /api/teachers/{id}
  Future<bool> updateTeacher(TeacherModel updatedTeacher) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.updateTeacher(
        updatedTeacher.teacherId,
        updatedTeacher,
      );

      final index = _teachers.indexWhere((t) => t.teacherId == result.teacherId);
      if (index != -1) {
        _teachers[index] = result;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Could not update teacher details.';
      debugPrint('TeacherProvider update error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 4. DELETE: DELETE /api/teachers/{id}
  Future<bool> deleteTeacher(String teacherId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.deleteTeacher(teacherId);
      _teachers.removeWhere((t) => t.teacherId == teacherId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Could not delete teacher.';
      debugPrint('TeacherProvider delete error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}