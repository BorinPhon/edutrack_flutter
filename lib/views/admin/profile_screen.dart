import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../auth/login_screen.dart';
import 'app_bottom_navigation.dart';
import 'change_password_screen.dart';
import '../../models/Login/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF2E7D32);

    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.loginResponse!.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 20),

            CircleAvatar(
              radius: 60,
              backgroundImage: user.profile.isNotEmpty
                  ? NetworkImage(
                "${ApiService.serverUrl}/image/${user.profileFolder}/${user.profile}",
              )
                  : null,
              child: user.profile.isEmpty
                  ? const Icon(Icons.person, size: 60)
                  : null,
            ),

            const SizedBox(height: 16),

            Text(
              user != null
                  ? "${user.firstName} ${user.lastName}"
                  : "Administrator",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              user?.email ?? "",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 10),

            Chip(
              backgroundColor: Colors.green.shade100,
              avatar: const Icon(
                Icons.verified_user,
                color: Colors.green,
                size: 18,
              ),
              label: Text(
                user != null && user.roles.isNotEmpty
                    ? user.roles.first.name
                    : "ADMIN",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [

                  ListTile(
                    leading: const Icon(Icons.badge),
                    title: const Text("Full Name"),
                    subtitle: Text(
                      user != null
                          ? "${user.firstName} ${user.lastName}"
                          : "-",
                    ),
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("Username"),
                    subtitle: Text(user.username ?? "-"),
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text("Email"),
                    subtitle: Text(user.email ?? "-"),
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text("Phone"),
                    subtitle: Text(user.phoneNumber ?? "-"),
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text("Role"),
                    subtitle: Text(
                      user.roles.isNotEmpty
                          ? user.roles.first.name
                          : "-",
                    ),
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(Icons.circle),
                    title: const Text("Status"),
                    subtitle: Text(user.status ?? "-"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [

                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: const Text("Change Password"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const ChangePasswordScreen(),
                        ),
                      );
                    }
                  ),

                  const Divider(height: 1),

                ],
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                onPressed: () async {

                  await context.read<AuthProvider>().logout();

                  if (!context.mounted) return;

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                        (route) => false,
                  );

                },
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(
        currentIndex: 3,
      ),
    );
  }
}