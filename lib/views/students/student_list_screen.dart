import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/student_model.dart';
import '../../providers/student_provider.dart';
import 'student_detail_screen.dart';
import 'student_form_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Fetch students when screen loads
    Future.microtask(() =>
        Provider.of<StudentProvider>(context, listen: false).fetchStudents()
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF2E7D32);
    const darkGreen = Color(0xFF1B5E20);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: const Text('Students Directory'),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Input
            TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim().toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by name or email...',
                prefixIcon: const Icon(Icons.search, color: primaryGreen),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
                    : null,
              ),
            ),
            const SizedBox(height: 16),

            // Provider Consumer Section
            Expanded(
              child: Consumer<StudentProvider>(
                builder: (context, studentProvider, child) {
                  if (studentProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: primaryGreen),
                    );
                  }

                  // Filter students dynamically based on search query
                  final filteredStudents = studentProvider.students.where((s) {
                    final nameMatch = s.fullName.toLowerCase().contains(_searchQuery);
                    final emailMatch = (s.email ?? '').toLowerCase().contains(_searchQuery);
                    return nameMatch || emailMatch;
                  }).toList();

                  return Column(
                    children: [
                      // Total Count Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total: ${filteredStudents.length} students',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: darkGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // List View
                      Expanded(
                        child: filteredStudents.isEmpty
                            ? Center(
                          child: Text(
                            'No students found',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        )
                            : ListView.builder(
                          itemCount: filteredStudents.length,
                          itemBuilder: (context, index) {
                            final student = filteredStudents[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                leading: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: const Color(0xFFE8F5E9),
                                  child: Text(
                                    student.firstName.isNotEmpty
                                        ? student.firstName[0].toUpperCase()
                                        : 'S',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryGreen,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  student.fullName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  student.email ?? 'No email provided',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.chevron_right,
                                  color: primaryGreen,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StudentDetailScreen(
                                        student: student,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StudentFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}