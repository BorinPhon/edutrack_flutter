import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/teacher_model.dart';
import '../../providers/teacher_provider.dart';
import 'teacher_detail_screen.dart';
import 'teacher_form_screen.dart';

class TeacherListScreen extends StatefulWidget {
  const TeacherListScreen({super.key});

  @override
  State<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Fetch teachers when screen loads
    Future.microtask(() =>
        Provider.of<TeacherProvider>(context, listen: false).fetchTeachers()
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
        title: const Text('Teachers Directory'),
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
                hintText: 'Search by name, position, or email...',
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
              child: Consumer<TeacherProvider>(
                builder: (context, teacherProvider, child) {
                  if (teacherProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: primaryGreen),
                    );
                  }

                  // Filter teachers dynamically based on search query
                  final filteredTeachers = teacherProvider.teachers.where((t) {
                    final nameMatch = t.fullName.toLowerCase().contains(_searchQuery);
                    final posMatch = (t.position ?? '').toLowerCase().contains(_searchQuery);
                    final emailMatch = (t.email ?? '').toLowerCase().contains(_searchQuery);
                    return nameMatch || posMatch || emailMatch;
                  }).toList();

                  return Column(
                    children: [
                      // Total Count Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total: ${filteredTeachers.length} teachers',
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
                        child: filteredTeachers.isEmpty
                            ? Center(
                          child: Text(
                            'No teachers found',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        )
                            : ListView.builder(
                          itemCount: filteredTeachers.length,
                          itemBuilder: (context, index) {
                            final teacher = filteredTeachers[index];
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
                                    teacher.firstName.isNotEmpty
                                        ? teacher.firstName[0].toUpperCase()
                                        : 'T',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryGreen,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  teacher.fullName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      teacher.position ?? 'Faculty Member',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: primaryGreen,
                                        fontSize: 13,
                                      ),
                                    ),
                                    if (teacher.email != null)
                                      Text(
                                        teacher.email!,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                        ),
                                      ),
                                  ],
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: teacher.isActive
                                        ? Colors.green.shade100
                                        : Colors.red.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    teacher.isActive ? 'Active' : 'Inactive',
                                    style: TextStyle(
                                      color: teacher.isActive
                                          ? Colors.green.shade800
                                          : Colors.red.shade800,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TeacherDetailScreen(
                                        teacher: teacher,
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
              builder: (context) => const TeacherFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}