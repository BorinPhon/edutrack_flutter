import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Utils/helper.dart';
import '../../models/teacher/teacher_model.dart';
import '../../providers/teacher_provider.dart';
import '../../services/api_service.dart';
import 'teacher_form_screen.dart';
class TeacherDetailScreen extends StatelessWidget {
  final TeacherModel teacher;

  const TeacherDetailScreen({
    super.key,
    required this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF2E7D32);

    return Consumer<TeacherProvider>(
      builder: (context, provider, child) {

        final currentTeacher = provider.teachers.firstWhere(
              (t) => t.id == teacher.id,
          orElse: () => teacher,
        );

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),

          appBar: AppBar(
            title: const Text("Teacher Detail"),
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,

            actions: [

              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {

                  final result =
                  await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          TeacherFormScreen(
                            teacher: currentTeacher,
                          ),
                    ),
                  );

                  if (result == true) {
                    await provider.fetchTeachers();

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
                    currentTeacher,
                  );
                },
              ),

            ],
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [

                buildHeader(currentTeacher),

                const SizedBox(height: 20),

                buildPersonalInformation(currentTeacher),

                const SizedBox(height: 20),

                buildAccountInformation(currentTeacher),

                const SizedBox(height: 20),
                buildAuditInformation(currentTeacher),


              ],
            ),
          ),
        );
      },
    );
  }
  Widget buildHeader(
      TeacherModel teacher,
      ) {
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
              backgroundImage:
              teacher.photo != null && teacher.photo!.isNotEmpty
                  ? NetworkImage(
                "${ApiService.serverUrl}/image/teachers/${teacher.photo}",
              )
                  : null,
            ),

            const SizedBox(height: 16),

            Text(
              teacher.fullName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "@${teacher.username}",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              teacher.email ?? "-",
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 16),

            Chip(
              avatar: Icon(
                Icons.circle,
                size: 14,
                color: teacher.isActive
                    ? Colors.green
                    : Colors.red,
              ),
              label: Text(
                teacher.isActive
                    ? "Active"
                    : "Inactive",
              ),
            ),

          ],
        ),
      ),
    );
  }
  Widget buildPersonalInformation(
      TeacherModel teacher,
      ) {
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
              "Teacher ID",
              teacher.id.toString(),
            ),

            buildInfoRow(
              "User ID",
              teacher.userId.toString(),
            ),

            buildInfoRow(
              "First Name",
              teacher.firstName,
            ),

            buildInfoRow(
              "Last Name",
              teacher.lastName,
            ),

            buildInfoRow(
              "Gender",
              teacher.gender ?? "-",
            ),

            buildInfoRow(
              "Date of Birth",
              teacher.dateOfBirth?.toString().split(" ").first ?? "-",
            ),

            buildInfoRow(
              "Phone",
              teacher.phone ?? "-",
            ),

            buildInfoRow(
              "Address",
              teacher.address ?? "-",
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
  Widget buildAccountInformation(
      TeacherModel teacher,
      ) {
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
              teacher.username,
            ),

            buildInfoRow(
              "Email",
              teacher.email ?? "-",
            ),

          ],
        ),
      ),
    );
  }
  Widget buildAuditInformation(
      TeacherModel teacher,
      ) {
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
              formatDate(teacher.createdAt),
            ),

            buildInfoRow(
              "Updated At",
              formatDate(teacher.updatedAt),
            ),

          ],
        ),
      ),
    );
  }
  Future<void> showDeleteDialog(
      BuildContext context,
      TeacherModel teacher,
      ) async {

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Teacher"),
          content: Text(
            "Are you sure you want to delete '${teacher.fullName}'?",
          ),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Delete"),
            ),

          ],
        );
      },
    );

    if (confirm != true) return;

    if (!context.mounted) return;

    final provider = context.read<TeacherProvider>();

    final success =
    await provider.deleteTeacher(teacher.id);

    if (!context.mounted) return;

    if (success) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Teacher deleted successfully."),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ??
                "Delete failed.",
          ),
          backgroundColor: Colors.red,
        ),
      );

    }
  }
}