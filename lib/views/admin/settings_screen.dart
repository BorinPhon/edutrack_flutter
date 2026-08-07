import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import 'about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF2E7D32);

    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [

          const SizedBox(height: 10),

          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            subtitle: const Text("Enable dark theme"),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              context.read<ThemeProvider>().toggleTheme(value);
            },
          ),

          const Divider(height: 1),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About"),
            subtitle: const Text("Application information"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AboutScreen(),
                ),
              );
            },
          ),

        ],
      ),
    );
  }
}