import 'package:flutter/material.dart';
import 'package:project_final_fullstack/views/admin/profile_screen.dart';

import '../students/student_list_screen.dart';
import '../teachers/teacher_list_screen.dart';
import 'admin_dashboard_screen.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF2E7D32);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryGreen,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,

      onTap: (index) {

        if (index == currentIndex) return;

        Widget page;

        switch (index) {

          case 0:
            page = const AdminDashboardScreen();
            break;

          case 1:
            page = const StudentListScreen();
            break;

          case 2:
            page = const TeacherListScreen();
            break;

          case 3:
            page = const ProfileScreen();
            break;

          default:
            page = const AdminDashboardScreen();

        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => page,
          ),
        );

      },

      items: const [

        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: "Students",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Teachers",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: "Profile",
        ),

      ],
    );
  }
}