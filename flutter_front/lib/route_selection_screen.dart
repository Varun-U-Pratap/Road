// lib/route_selection_screen.dart

import 'package:flutter/material.dart';
import 'user_screen.dart';

class RouteSelectionScreen extends StatelessWidget {
  const RouteSelectionScreen({super.key});

  // In a real app, this would come from an API.
  final List<String> availableRoutes = const ['Route 7B', 'Route 12C', 'Airport Shuttle'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Route'),
      ),
      body: ListView.builder(
        itemCount: availableRoutes.length,
        itemBuilder: (context, index) {
          final routeId = availableRoutes[index];
          return ListTile(
            leading: const Icon(Icons.directions_bus),
            title: Text(routeId),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  // Pass the selected routeId to the UserScreen
                  builder: (_) => UserScreen(routeId: routeId),
                ),
              );
            },
          );
        },
      ),
    );
  }
}