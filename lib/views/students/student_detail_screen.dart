import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/student_model.dart';
import '../../providers/student_provider.dart';
import 'student_form_screen.dart';

class StudentDetailScreen extends StatelessWidget {
  final StudentModel student;

  const StudentDetailScreen({super.key, required this.student});

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);

              final success = await Provider.of<StudentProvider>(context, listen: false)
                  .deleteStudent(student.studentId);

              if (!context.mounted) return;

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${student.fullName} deleted.'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF2E7D32);

    return Consumer<StudentProvider>(
      builder: (context, studentProvider, child) {
        final currentStudent = studentProvider.students.firstWhere(
              (s) => s.studentId == student.studentId,
          orElse: () => student,
        );

        final dobStr = currentStudent.dateOfBirth != null
            ? '${currentStudent.dateOfBirth!.year}-${currentStudent.dateOfBirth!.month.toString().padLeft(2, '0')}-${currentStudent.dateOfBirth!.day.toString().padLeft(2, '0')}'
            : 'N/A';

        return Scaffold(
          backgroundColor: const Color(0xFFF1F8E9),
          appBar: AppBar(
            title: const Text('Student Profile'),
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentFormScreen(student: currentStudent),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _showDeleteDialog(context),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header Profile Card
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: const Color(0xFFE8F5E9),
                          backgroundImage: (currentStudent.photo != null && currentStudent.photo!.isNotEmpty)
                              ? NetworkImage(currentStudent.photo!)
                              : null,
                          child: (currentStudent.photo == null || currentStudent.photo!.isEmpty)
                              ? Text(
                            currentStudent.firstName.isNotEmpty ? currentStudent.firstName[0].toUpperCase() : 'S',
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryGreen),
                          )
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          currentStudent.fullName,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentStudent.email ?? 'No email',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: currentStudent.isActive ? Colors.green.shade100 : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            currentStudent.isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              color: currentStudent.isActive ? Colors.green.shade800 : Colors.red.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Details Card
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Personal Details',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryGreen),
                        ),
                        const Divider(),
                        _buildDetailTile(Icons.badge_outlined, 'Student ID', currentStudent.studentId),
                        _buildDetailTile(Icons.person_outline, 'User ID', currentStudent.userId),
                        _buildDetailTile(Icons.wc_outlined, 'Gender', currentStudent.gender ?? 'N/A'),
                        _buildDetailTile(Icons.cake_outlined, 'Date of Birth', dobStr),
                        _buildDetailTile(Icons.phone_outlined, 'Phone', currentStudent.phone ?? 'N/A'),
                        _buildDetailTile(Icons.home_outlined, 'Address', currentStudent.address ?? 'N/A'),
                        _buildDetailTile(Icons.image_outlined, 'Photo URL', currentStudent.photo ?? 'N/A'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF2E7D32)),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}