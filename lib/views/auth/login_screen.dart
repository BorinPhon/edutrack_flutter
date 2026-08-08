import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../admin/admin_dashboard_screen.dart';
import '../students/student_list_screen.dart';
import '../teachers/teacher_list_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.login(
      phoneNumber: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      final role =
          authProvider.loginResponse!.user.roles.first.name;

      switch (role) {
        case "ROLE_ADMIN":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const AdminDashboardScreen(),
            ),
          );
          break;

        case "ROLE_TEACHER":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const TeacherListScreen(),
            ),
          );
          break;

        default:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const StudentListScreen(),
            ),
          );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.errorMessage ?? "Login failed",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF2E7D32);
    const darkGreen = Color(0xFF1B5E20);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 32,
            ),
            child: Form(
              key: _formKey,
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8F5E9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.school,
                            size: 64,
                            color: primaryGreen,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        "EduTrack",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: darkGreen,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Sign in to your account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),

                      const SizedBox(height: 36),

                      TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Username",
                          hintText: "Enter username",
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter username";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon:
                          const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible =
                                !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter password";
                          }
                          return null;
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _showContactAdminDialog,
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: primaryGreen),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      if (authProvider.errorMessage != null)
                        Padding(
                          padding:
                          const EdgeInsets.only(bottom: 12),
                          child: Text(
                            authProvider.errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: authProvider.isLoading
                              ? null
                              : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                          ),
                          child: authProvider.isLoading
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child:
                            CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                              : const Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                          TextButton(
                            onPressed: _showContactAdminDialog,
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                color: primaryGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _showContactAdminDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Contact Administrator"),
        content: const Text(
          "Please contact the administrator to create an account or reset your password.\n\nPhone: 015 237 422",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}