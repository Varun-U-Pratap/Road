// lib/driver_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mock_location_service.dart';
import 'data/mock_data.dart'; // Import the central mock data file

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});
  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  bool _isSharing = false;
  String? _selectedRouteId; // We'll now use the route's busId

  void _toggleSharing() {
    if (_selectedRouteId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a route first!'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final locationService = Provider.of<MockLocationService>(context, listen: false);
    setState(() {
      _isSharing = !_isSharing;
      if (_isSharing) {
        locationService.startSharing(_selectedRouteId!);
      } else {
        locationService.stopSharing();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver Dashboard')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('SELECT YOUR CURRENT ROUTE', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              // The Dropdown now builds its items from the mockRoutes list
              DropdownButtonFormField<String>(
                value: _selectedRouteId,
                hint: const Text('Select Route'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                // Build items from the central mockRoutes list
                items: mockRoutes.map((BusRoute route) {
                  return DropdownMenuItem<String>(
                    value: route.busId,
                    child: Text(route.routeName, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (newValue) => setState(() => _selectedRouteId = newValue),
              ),
              const SizedBox(height: 60),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                child: Icon(
                  _isSharing ? Icons.location_on : Icons.location_off,
                  key: ValueKey<bool>(_isSharing),
                  size: 100,
                  color: _isSharing ? Colors.teal : Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _isSharing ? 'Live Location Sharing is ON' : 'Live Location Sharing is OFF',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _toggleSharing,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSharing ? Colors.redAccent : Colors.teal,
                  ),
                  child: Text(_isSharing ? 'Stop Sharing' : 'Start Sharing'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}