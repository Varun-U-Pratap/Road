// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'mock_location_service.dart';
import 'login_screen.dart';
import 'theme_controller.dart';

void main() {
  final ThemeController themeController = Get.put(ThemeController()); // Initialize controller
  runApp(MyApp(themeController: themeController));
}

class MyApp extends StatelessWidget {
  final ThemeController themeController;
  const MyApp({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme(
      // ... (same GoogleFonts textTheme from before)
    );

    return Provider<MockLocationService>(
      create: (_) => MockLocationService(),
      dispose: (_, service) => service.dispose(),
      child: Obx(() => // Use Obx to listen to theme changes
         GetMaterialApp( // Use GetMaterialApp instead of MaterialApp
            title: 'LiveTrack',
            debugShowCheckedModeBanner: false,
            // Light Theme
            theme: ThemeData(
              // ... (same light theme from before)
            ),
            // Dark Theme
            darkTheme: ThemeData(
              // ... (same dark theme from before)
            ),
            themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
            home: const LoginScreen(),
          )),
    );
  }
}