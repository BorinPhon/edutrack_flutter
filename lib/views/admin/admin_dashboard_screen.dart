import 'package:flutter/material.dart';
import '../../widgets/quick_access_card.dart';
import '../students/student_list_screen.dart';
import '../teachers/teacher_list_screen.dart';
import '../auth/login_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF2E7D32);
    const darkGreen = Color(0xFF1B5E20);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9), // Soft Mint Background
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {

              final authProvider = context.read<AuthProvider>();

              await authProvider.logout();

              if(!context.mounted) return;

              Navigator.pushAndRemoveUntil(

                context,

                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),

                    (route) => false,

              );

            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header
              const Text(
                'Welcome Back, Admin 👋',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'System Overview & Quick Management',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 20),

              // 1. STATS OVERVIEW SECTION
              const Text(
                'Statistics',
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
                      title: 'Students',
                      count: '128',
                      icon: Icons.school,
                      color: primaryGreen,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StudentListScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Teachers',
                      count: '24',
                      icon: Icons.person_outline,
                      color: const Color(0xFF388E3C),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TeacherListScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Total Accounts Card
              _buildFullStatCard(
                title: 'Total System Accounts',
                count: '152 Active Users',
                icon: Icons.people_alt_outlined,
                color: darkGreen,
              ),

              const SizedBox(height: 28),

              // 2. QUICK MANAGEMENT ACTIONS
              const Text(
                'Quick Actions',
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StudentListScreen(),
                          ),
                        );
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TeacherListScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),


              const SizedBox(height: 28),

              // 3. RECENT ACTIVITY LOGS
              const Text(
                'Recent System Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),
              const SizedBox(height: 12),


            ],
          ),
        ),
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
}