import 'package:flutter/material.dart';
import 'package:project_final_fullstack/views/admin/profile_screen.dart';
import 'package:project_final_fullstack/views/admin/settings_screen.dart';
import '../../widgets/quick_access_card.dart';
import '../students/student_list_screen.dart';
import '../teachers/teacher_list_screen.dart';
import '../auth/login_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'notification_screen.dart';
import '../../providers/student_provider.dart';
import '../../providers/teacher_provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState
    extends State<AdminDashboardScreen> {

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await context.read<StudentProvider>().fetchStudents();
      await context.read<TeacherProvider>().fetchTeachers();
    });
  }

  @override
  Widget build(BuildContext context)  {


    const primaryGreen = Color(0xFF2E7D32);
    const darkGreen = Color(0xFF1B5E20);

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            const UserAccountsDrawerHeader(

              accountName: Text("Administrator"),

              accountEmail: Text("admin@school.com"),

              currentAccountPicture: CircleAvatar(
                child: Icon(
                  Icons.person,
                  size: 40,
                ),
              ),

              decoration: BoxDecoration(
                color: Color(0xFF2E7D32),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Dashboard"),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.school),
              title: const Text("Students"),
              onTap: () {

                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const StudentListScreen(),
                  ),
                );

              },
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Teachers"),
              onTap: () {

                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const TeacherListScreen(),
                  ),
                );

              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {

                final authProvider =
                context.read<AuthProvider>();

                await authProvider.logout();

                if (!context.mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const LoginScreen(),
                  ),
                      (route) => false,
                );

              },
            ),

          ],
        ),
      ),
      backgroundColor: const Color(0xFFF1F8E9), // Soft Mint Background
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,

        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),

        actions: [

          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationScreen(),
                ),
              );
            },
          ),

        ],
      ),
      body: _getCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
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
      ),
    );
  }

  // Stat Card Widget
  Widget _buildStatCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color.withOpacity(0.12),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 12),
              Text(
                count,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Full-width Stat Card Widget
  Widget _buildFullStatCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: color.withOpacity(0.12),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 👇 OUTSIDE build()
  Widget _getCurrentPage() {

    switch (_selectedIndex) {

      case 0:
        return _buildHomePage();

      case 1:
        return const StudentListScreen();

      case 2:
        return const TeacherListScreen();

      case 3:
        return const ProfileScreen();

      default:
        return _buildHomePage();

    }

  }
  Widget _buildHomePage() {
    const primaryGreen = Color(0xFF2E7D32);
    const darkGreen = Color(0xFF1B5E20);
    // Get providers
    final studentProvider = context.watch<StudentProvider>();
    final teacherProvider = context.watch<TeacherProvider>();

    // Show loading while fetching data
    if (studentProvider.isLoading || teacherProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    final studentCount = context.watch<StudentProvider>().students.length;
    final teacherCount = context.watch<TeacherProvider>().teachers.length;
    return SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<StudentProvider>().fetchStudents();
            await context.read<TeacherProvider>().fetchTeachers();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "Welcome Back 👋",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "Administrator",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  "Statistics",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [

                    Expanded(
                      child: _buildStatCard(
                        title: "Students",
                        count:  studentCount.toString(),
                        icon: Icons.school,
                        color: primaryGreen,
                        onTap: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _buildStatCard(
                        title: "Teachers",
                        count: teacherCount.toString(),
                        icon: Icons.person_outline,
                        color: Colors.green,
                        onTap: () {
                          setState(() {
                            _selectedIndex = 2;
                          });
                        },
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 30),

                const Text(
                  "Quick Access",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [

                    Expanded(
                      child: QuickAccessCard(
                        title: "Students",
                        icon: Icons.school,
                        iconColor: Colors.blue,
                        backgroundColor: const Color(0xFFEAF4FF),
                        onTap: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: QuickAccessCard(
                        title: "Teachers",
                        icon: Icons.person,
                        iconColor: Colors.green,
                        backgroundColor: const Color(0xFFEAF4FF),
                        onTap: () {
                          setState(() {
                            _selectedIndex = 2;
                          });
                        },
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 30),

              ],
            ),
          ),
        ),
    );
  }
}