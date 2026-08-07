import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF2E7D32);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.notifications_off_outlined,
              size: 90,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 20),

            const Text(
              "No Notifications",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "You don't have any notifications yet.",
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

          ],
        ),
      ),
    );
  }
}