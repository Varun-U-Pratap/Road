// lib/driver_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mock_location_service.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});
  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  bool _isSharing = false;
  String? _selectedRoute;
  final List<String> _availableRoutes = const ['Route 7B', 'Route 12C', 'Airport Shuttle'];

  void _toggleSharing() {
    if (_selectedRoute == null) {
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
        locationService.startSharing(_selectedRoute!);
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
              Text('SELECT YOUR ROUTE', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedRoute,
                hint: const Text('Select Route'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                items: _availableRoutes.map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
                onChanged: (newValue) => setState(() => _selectedRoute = newValue),
              ),
              const SizedBox(height: 60),
              // AnimatedSwitcher for smooth icon transition
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                child: Icon(
                  _isSharing ? Icons.location_on : Icons.location_off,
                  key: ValueKey<bool>(_isSharing), // Important for AnimatedSwitcher
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