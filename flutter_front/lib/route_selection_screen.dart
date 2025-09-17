// lib/route_selection_screen.dart
import 'package:flutter/material.dart';
import 'data/mock_data.dart';
import 'user_screen.dart';
import 'settings_screen.dart'; // Import settings screen

class RouteSelectionScreen extends StatefulWidget {
  const RouteSelectionScreen({super.key});
  @override
  State<RouteSelectionScreen> createState() => _RouteSelectionScreenState();
}

class _RouteSelectionScreenState extends State<RouteSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Routes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: // ... (The animated ListView.builder from before remains the same)
    );
  }

  Widget _buildRouteCard(BusRoute route) {
    return Card(
      // ... (Card styling from before)
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (_, __, ___) => UserScreen(routeId: route.busId),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // This Hero widget enables the transition
              Hero(
                tag: 'bus_icon_${route.busId}',
                child: Container(
                  // ... (Icon container styling from before)
                  child: Icon(Icons.directions_bus, color: Theme.of(context).colorScheme.primary, size: 30),
                ),
              ),
              // ... (Rest of the list tile content)
            ],
          ),
        ),
      ),
    );
  }
}