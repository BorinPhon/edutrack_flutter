import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF2E7D32);

    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            const SizedBox(height: 20),

            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.green.shade100,
              child: const Icon(
                Icons.school,
                color: primaryGreen,
                size: 50,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "EduTrack",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Student Management System",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            const Card(
              child: ListTile(
                leading: Icon(Icons.verified),
                title: Text("Version"),
                subtitle: Text("1.0.0"),
              ),
            ),

            const Card(
              child: ListTile(
                leading: Icon(Icons.code),
                title: Text("Developed By"),
                subtitle: Text("NEW TECH"),
              ),
            ),

            const Card(
              child: ListTile(
                leading: Icon(Icons.storage),
                title: Text("Backend"),
                subtitle: Text("Spring Boot + PostgreSQL"),
              ),
            ),

            const Card(
              child: ListTile(
                leading: Icon(Icons.phone_android),
                title: Text("Frontend"),
                subtitle: Text("Flutter"),
              ),
            ),

            const Spacer(),

            const Text(
              "© 2026 EduTrack",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 10),

          ],
        ),
      ),
    );
  }
}