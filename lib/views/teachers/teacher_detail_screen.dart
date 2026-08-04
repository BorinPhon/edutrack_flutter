import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/teacher_model.dart';
import '../../providers/teacher_provider.dart';
import 'teacher_form_screen.dart';

class TeacherDetailScreen extends StatelessWidget {
  final TeacherModel teacher;

  const TeacherDetailScreen({super.key, required this.teacher});

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Teacher'),
        content: Text('Are you sure you want to delete ${teacher.fullName}?'),
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

              final success = await Provider.of<TeacherProvider>(context, listen: false)
                  .deleteTeacher(teacher.teacherId);

              if (!context.mounted) return;

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${teacher.fullName} deleted.'),
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

    return Consumer<TeacherProvider>(
      builder: (context, teacherProvider, child) {
        final currentTeacher = teacherProvider.teachers.firstWhere(
              (t) => t.teacherId == teacher.teacherId,
          orElse: () => teacher,
        );

        final dobStr = currentTeacher.dateOfBirth != null
            ? '${currentTeacher.dateOfBirth!.year}-${currentTeacher.dateOfBirth!.month.toString().padLeft(2, '0')}-${currentTeacher.dateOfBirth!.day.toString().padLeft(2, '0')}'
            : 'N/A';

        final hireStr = currentTeacher.hireDate != null
            ? '${currentTeacher.hireDate!.year}-${currentTeacher.hireDate!.month.toString().padLeft(2, '0')}-${currentTeacher.hireDate!.day.toString().padLeft(2, '0')}'
            : 'N/A';

        return Scaffold(
          backgroundColor: const Color(0xFFF1F8E9),
          appBar: AppBar(
            title: const Text('Teacher Profile'),
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeacherFormScreen(teacher: currentTeacher),
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
                          backgroundImage: (currentTeacher.photo != null && currentTeacher.photo!.isNotEmpty)
                              ? NetworkImage(currentTeacher.photo!)
                              : null,
                          child: (currentTeacher.photo == null || currentTeacher.photo!.isEmpty)
                              ? Text(
                            currentTeacher.firstName.isNotEmpty ? currentTeacher.firstName[0].toUpperCase() : 'T',
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryGreen),
                          )
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          currentTeacher.fullName,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentTeacher.position ?? 'Faculty Member',
                          style: const TextStyle(color: primaryGreen, fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentTeacher.email ?? 'No email',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: currentTeacher.isActive ? Colors.green.shade100 : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            currentTeacher.isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              color: currentTeacher.isActive ? Colors.green.shade800 : Colors.red.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Employment & Personal Details Card
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Employment & Personal Info',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryGreen),
                        ),
                        const Divider(),
                        _buildDetailTile(Icons.badge_outlined, 'Teacher ID', currentTeacher.teacherId),
                        _buildDetailTile(Icons.person_outline, 'User ID', currentTeacher.userId),
                        _buildDetailTile(Icons.school_outlined, 'Qualification', currentTeacher.qualification ?? 'N/A'),
                        _buildDetailTile(Icons.attach_money, 'Salary', currentTeacher.salary != null ? '\$${currentTeacher.salary!.toStringAsFixed(2)}' : 'N/A'),
                        _buildDetailTile(Icons.calendar_month_outlined, 'Hire Date', hireStr),
                        _buildDetailTile(Icons.wc_outlined, 'Gender', currentTeacher.gender ?? 'N/A'),
                        _buildDetailTile(Icons.cake_outlined, 'Date of Birth', dobStr),
                        _buildDetailTile(Icons.phone_outlined, 'Phone', currentTeacher.phone ?? 'N/A'),
                        _buildDetailTile(Icons.home_outlined, 'Address', currentTeacher.address ?? 'N/A'),
                        _buildDetailTile(Icons.image_outlined, 'Photo URL', currentTeacher.photo ?? 'N/A'),
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
            width: 110,
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