// lib/login_screen.dart

import 'package:flutter/material.dart';
import 'driver_screen.dart';
// Import the new route selection screen
import 'route_selection_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Role'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ... The Driver button remains the same
            ElevatedButton.icon(
              icon: const Icon(Icons.drive_eta),
              label: const Text('Login as Driver'),
              // ... style
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const DriverScreen()),
                );
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.person),
              label: const Text('Login as User'),
              // ... style
              onPressed: () {
                // THIS IS THE CHANGE: Navigate to route selection instead of directly to the map
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RouteSelectionScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}