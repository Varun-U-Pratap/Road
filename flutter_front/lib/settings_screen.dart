// lib/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Find the theme controller instance
    final ThemeController themeController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => // Obx rebuilds when the observable changes
         ListTile(
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: themeController.isDarkMode.value,
                onChanged: (value) {
                  themeController.toggleTheme();
                },
              ),
            )),
      ),
    );
  }
}