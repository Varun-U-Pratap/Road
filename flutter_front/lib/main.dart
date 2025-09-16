// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mock_location_service.dart';
import 'login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the MockLocationService to the entire app
    return Provider<MockLocationService>(
      create: (_) => MockLocationService(),
      dispose: (_, service) => service.dispose(),
      child: MaterialApp(
        title: 'Transport Tracker Prototype',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}