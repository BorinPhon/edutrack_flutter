import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/student_provider.dart';
import '../../models/student/student_model.dart';
import '../../services/api_service.dart';
import '../admin/admin_dashboard_screen.dart';
import '../admin/app_bottom_navigation.dart';
import '../admin/profile_screen.dart';
import '../teachers/teacher_list_screen.dart';
import 'student_detail_screen.dart';
import 'student_form_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchText = '';

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<StudentProvider>().fetchStudents();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text("Student List"),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: Column(
        children: [

          _buildSearchBox(),

          Expanded(
            child: Consumer<StudentProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return _buildLoading();
                }

                if (provider.errorMessage != null) {
                  return _buildError(provider);
                }

                final students = provider.students.where((student) {
                  final keyword = _searchText.toLowerCase();

                  return student.fullName.toLowerCase().contains(keyword) ||
                      student.username.toLowerCase().contains(keyword) ||
                      (student.email ?? "").toLowerCase().contains(keyword) ||
                      (student.phone ?? "").toLowerCase().contains(keyword);
                }).toList();

                if (students.isEmpty) {
                  return _buildEmpty();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await provider.fetchStudents();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];

                      return _buildStudentCard(student);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => const StudentFormScreen(),
            ),
          );

          if (result == true) {
            await context.read<StudentProvider>().fetchStudents();
          }
        },
      ),
      bottomNavigationBar: const AppBottomNavigation(
        currentIndex: 1,
      ),
    );
  }
  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search student...",
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchText.isEmpty
              ? null
              : IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();

              setState(() {
                _searchText = "";
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchText = value;
          });
        },
      ),
    );
  }
  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF2E7D32),
      ),
    );
  }
  Widget _buildError(StudentProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red,
          ),

          const SizedBox(height: 20),

          Text(
            provider.errorMessage ?? "Unknown Error",
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              provider.fetchStudents();
            },
            child: const Text("Retry"),
          )

        ],
      ),
    );
  }
  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(
            Icons.school_outlined,
            size: 80,
            color: Colors.grey,
          ),

          SizedBox(height: 20),

          Text(
            "No Students Found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

        ],
      ),
    );
  }
  Widget _buildStudentCard(StudentModel student) {
    const primaryGreen = Color(0xFF2E7D32);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => StudentDetailScreen(
                student: student,
              ),
            ),
          );

          if (result == true) {
            await context.read<StudentProvider>().fetchStudents();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [

              //--------------------------------
              // Avatar
              //--------------------------------

              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.green.shade100,
                backgroundImage: student.photo != null &&
                    student.photo!.isNotEmpty
                    ? NetworkImage(
                  "${ApiService.serverUrl}/image/students/${student.photo}",
                )
                    : null,
                child: student.photo == null ||
                    student.photo!.isEmpty
                    ? Text(
                  student.firstName.isNotEmpty
                      ? student.firstName[0].toUpperCase()
                      : "?",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
                  ),
                )
                    : null,
              ),

              const SizedBox(width: 16),

              //--------------------------------
              // Student Information
              //--------------------------------

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      student.fullName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Username : ${student.username}",
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Email : ${student.email ?? '-'}",
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Phone : ${student.phone ?? '-'}",
                    ),

                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: student.isActive
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        student.isActive
                            ? "Active"
                            : "Inactive",
                        style: TextStyle(
                          color: student.isActive
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //--------------------------------
              // Arrow
              //--------------------------------

              const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFFE8F5E9),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: primaryGreen,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}