import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Utils/helper.dart';
import '../../models/student/student_model.dart';
import '../../providers/student_provider.dart';
import '../../services/api_service.dart';
import 'student_form_screen.dart';

class StudentDetailScreen extends StatelessWidget {
  final StudentModel student;

  const StudentDetailScreen({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF2E7D32);

    return Consumer<StudentProvider>(
      builder: (context, provider, child) {
        final currentStudent = provider.students.firstWhere(
              (s) => s.id == student.id,
          orElse: () => student,
        );

        return Scaffold(
          backgroundColor: const Color(0xFFF1F8E9),

          appBar: AppBar(
            title: const Text("Student Detail"),
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,

            actions: [

              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          StudentFormScreen(
                            student: currentStudent,
                          ),
                    ),
                  );

                  if (!context.mounted) return;

                  if (result == true) {
                    await provider.fetchStudents();

                    if (context.mounted) {
                      Navigator.pop(context, true);
                    }
                  }
                },
              ),

              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDeleteDialog(
                    context,
                    currentStudent,
                  );
                },
              ),

            ],
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [

                buildHeader(currentStudent),

                const SizedBox(height: 20),

                buildPersonalInformation(currentStudent),

                const SizedBox(height: 20),

                buildAccountInformation(currentStudent),

                const SizedBox(height: 20),
                buildAuditInformation(currentStudent),

              ],
            ),
          ),
        );
      },
    );
  }
  Widget buildAuditInformation(StudentModel student) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Audit Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(height: 30),

            buildInfoRow(
              "Created At",
              formatDate(student.createdAt),
            ),

            buildInfoRow(
              "Updated At",
              formatDate(student.updatedAt),
            ),

          ],
        ),
      ),
    );
  }
  Widget buildAccountInformation(StudentModel student) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Account Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(height: 30),

            buildInfoRow(
              "Username",
              student.username,
            ),

            buildInfoRow(
              "Email",
              student.email ?? "-",
            ),

            buildInfoRow(
              "Role",
              student.role ?? "-",
            ),

          ],
        ),
      ),
    );
  }
  Widget buildPersonalInformation(StudentModel student) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Personal Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(height: 30),

            buildInfoRow(
              "Student ID",
              student.id.toString(),
            ),

            buildInfoRow(
              "User ID",
              student.userId.toString(),
            ),

            buildInfoRow(
              "First Name",
              student.firstName,
            ),

            buildInfoRow(
              "Last Name",
              student.lastName,
            ),

            buildInfoRow(
              "Gender",
              student.gender ?? "-",
            ),

            buildInfoRow(
              "Date of Birth",
              student.dateOfBirth?.toString().split(" ").first ?? "-",
            ),

            buildInfoRow(
              "Phone",
              student.phone ?? "-",
            ),

            buildInfoRow(
              "Address",
              student.address ?? "-",
            ),

          ],
        ),
      ),
    );
  }
  Widget buildInfoRow(
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [

          SizedBox(
            width: 120,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),

        ],
      ),
    );
  }
  Widget buildHeader(StudentModel student) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
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
                student.firstName[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              student.fullName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "@${student.username}",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 16),
            Chip(
              avatar: Icon(
                Icons.circle,
                color: student.isActive ? Colors.green : Colors.red,
                size: 14,
              ),
              label: Text(
                student.isActive ? "Active" : "Inactive",
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> showDeleteDialog(
      BuildContext context,
      StudentModel student,
      ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Student"),
          content: Text(
            "Are you sure you want to delete '${student.fullName}'?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    if (!context.mounted) return;

    final provider = context.read<StudentProvider>();

    final success = await provider.deleteStudent(student.id);

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Student deleted successfully."),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? "Delete failed."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}