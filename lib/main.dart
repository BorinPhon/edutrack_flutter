import 'package:flutter/material.dart';
import 'package:project_final_fullstack/providers/auth_provider.dart';
import 'package:project_final_fullstack/views/splash/splash_screen.dart';
import 'package:provider/provider.dart'; // 1. Imported Provider package
import 'providers/student_provider.dart';
import 'providers/teacher_provider.dart';
import 'views/auth/login_screen.dart';

// 1. Import your AdminDashboardScreen
import 'views/admin/admin_dashboard_screen.dart';

void main() {
  runApp(
    // 2. Wrapped root app with MultiProvider
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => TeacherProvider()),
      ],
      child: const StudentManagementApp(),
    ),
  );
}

class StudentManagementApp extends StatelessWidget {
  const StudentManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF2E7D32);
    const darkGreen = Color(0xFF1B5E20);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudentManagement',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryGreen,
          primary: primaryGreen,
        ),
        useMaterial3: true,
        // Global input field theme configured for green borders
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Colors.black87),
          prefixIconColor: primaryGreen,
          suffixIconColor: primaryGreen,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          // Default unselected border
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
          ),
          // Focused / Inserting border (Green)
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryGreen, width: 2.0),
          ),
          // Error border
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
          ),
        ),
      ),
      // home: const LoginScreen(),
        home: const SplashScreen(),
    );
  }
}