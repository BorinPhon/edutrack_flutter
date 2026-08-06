import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/teacher/teacher_model.dart';
import '../../providers/teacher_provider.dart';
import 'teacher_detail_screen.dart';
import 'teacher_form_screen.dart';

class TeacherListScreen extends StatefulWidget {
  const TeacherListScreen({super.key});

  @override
  State<TeacherListScreen> createState() =>
      _TeacherListScreenState();
}

class _TeacherListScreenState
    extends State<TeacherListScreen> {

  final TextEditingController _searchController =
  TextEditingController();

  String _searchText = "";

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<TeacherProvider>().fetchTeachers();
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
        title: const Text("Teacher List"),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [

          _buildSearchBox(),

          Expanded(
            child: Consumer<TeacherProvider>(
              builder: (context, provider, child) {

                if (provider.isLoading) {
                  return _buildLoading();
                }

                if (provider.errorMessage != null) {
                  return _buildError(provider);
                }

                final teachers = provider.teachers.where((teacher) {

                  final keyword = _searchText.toLowerCase();

                  return teacher.fullName
                      .toLowerCase()
                      .contains(keyword) ||

                      teacher.username
                          .toLowerCase()
                          .contains(keyword) ||

                      (teacher.email ?? "")
                          .toLowerCase()
                          .contains(keyword) ||

                      (teacher.phone ?? "")
                          .toLowerCase()
                          .contains(keyword);

                }).toList();

                if (teachers.isEmpty) {
                  return _buildEmpty();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await provider.fetchTeachers();
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: teachers.length,
                    itemBuilder: (context, index) {

                      final teacher = teachers[index];

                      return _buildTeacherCard(teacher);

                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton:
      FloatingActionButton(

        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,

        child: const Icon(Icons.add),

        onPressed: () async {
          final result =
          await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const TeacherFormScreen(),
            ),
          );

          if (result == true) {
            await context
                .read<TeacherProvider>()
                .fetchTeachers();
          }
        },
      ),
    );
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search teacher...",
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
  Widget _buildError(
      TeacherProvider provider,
      ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const Icon(
            Icons.error_outline,
            size: 70,
            color: Colors.red,
          ),

          const SizedBox(height: 20),

          Text(
            provider.errorMessage ?? "Unknown Error",
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              provider.fetchTeachers();
            },
            child: const Text("Retry"),
          ),

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
            Icons.person_outline,
            size: 80,
            color: Colors.grey,
          ),

          SizedBox(height: 20),

          Text(
            "No Teachers Found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

        ],
      ),
    );
  }
  Widget _buildTeacherCard(TeacherModel teacher) {
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

          final result =
          await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => TeacherDetailScreen(
                teacher: teacher,
              ),
            ),
          );

          if (result == true) {
            await context
                .read<TeacherProvider>()
                .fetchTeachers();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [

              //----------------------------------
              // Avatar
              //----------------------------------

              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.green.shade100,
                child: Text(
                  teacher.firstName.isNotEmpty
                      ? teacher.firstName[0].toUpperCase()
                      : "?",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              //----------------------------------
              // Teacher Information
              //----------------------------------

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      teacher.fullName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "@${teacher.username}",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      teacher.email ?? "-",
                    ),

                    const SizedBox(height: 4),

                    Text(
                      teacher.phone ?? "-",
                    ),

                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: teacher.isActive
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        teacher.isActive
                            ? "Active"
                            : "Inactive",
                        style: TextStyle(
                          color: teacher.isActive
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              //----------------------------------
              // Arrow
              //----------------------------------

              const Icon(
                Icons.chevron_right,
                color: primaryGreen,
              ),

            ],
          ),
        ),
      ),
    );
  }
}