import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/student_provider.dart';
import 'providers/teacher_provider.dart';
import 'providers/theme_provider.dart';

import 'views/splash/splash_screen.dart';

Future<void> main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => TeacherProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
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

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'EduTrack',

          themeMode: themeProvider.themeMode,

          //-----------------------------------
          // LIGHT THEME
          //-----------------------------------

          theme: ThemeData(
            useMaterial3: true,

            colorScheme: ColorScheme.fromSeed(
              seedColor: primaryGreen,
              brightness: Brightness.light,
            ),

            scaffoldBackgroundColor: const Color(0xFFF5F7FA),

            appBarTheme: const AppBarTheme(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              centerTitle: true,
            ),

            floatingActionButtonTheme:
            const FloatingActionButtonThemeData(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
            ),

            cardTheme: CardThemeData(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),

            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: primaryGreen,
                  width: 2,
                ),
              ),

              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
              ),

              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
            ),
          ),

          //-----------------------------------
          // DARK THEME
          //-----------------------------------

          darkTheme: ThemeData(
            useMaterial3: true,

            colorScheme: ColorScheme.fromSeed(
              seedColor: primaryGreen,
              brightness: Brightness.dark,
            ),

            appBarTheme: const AppBarTheme(
              centerTitle: true,
            ),

            floatingActionButtonTheme:
            const FloatingActionButtonThemeData(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
            ),

            cardTheme: CardThemeData(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),

            inputDecorationTheme: InputDecorationTheme(
              filled: true,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: primaryGreen,
                  width: 2,
                ),
              ),
            ),
          ),

          home: const SplashScreen(),
        );
      },
    );
  }
}