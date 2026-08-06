import 'package:flutter/material.dart';

import '../models/teacher/teacher_model.dart';
import '../models/teacher/teacher_request.dart';
import '../services/teacher_api_service.dart';

class TeacherProvider extends ChangeNotifier {
  final TeacherApiService _apiService = TeacherApiService();

  List<TeacherModel> _teachers = [];

  bool _isLoading = false;

  String? _errorMessage;

  List<TeacherModel> get teachers => _teachers;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // ==========================
  // GET ALL
  // ==========================
  Future<void> fetchTeachers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _teachers = await _apiService.getAllTeachers();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }

  // ==========================
  // CREATE
  // ==========================
  Future<bool> addTeacher(
      TeacherRequest request,
      ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final teacher =
      await _apiService.createTeacher(request);

      _teachers.add(teacher);

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();

      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  // ==========================
  // UPDATE
  // ==========================
  Future<bool> updateTeacher(
      int id,
      TeacherRequest request,
      ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final teacher =
      await _apiService.updateTeacher(id, request);

      final index = _teachers.indexWhere(
            (t) => t.id == id,
      );

      if (index != -1) {
        _teachers[index] = teacher;
      }

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();

      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  // ==========================
  // DELETE
  // ==========================
  Future<bool> deleteTeacher(
      int id,
      ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.deleteTeacher(id);

      _teachers.removeWhere(
            (teacher) => teacher.id == id,
      );

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();

      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  // ==========================
  // GET BY ID (Optional)
  // ==========================
  Future<TeacherModel?> getTeacherById(
      int id,
      ) async {
    try {
      return await _apiService.getTeacherById(id);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }
}