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
  String? _selectedRoute; // The driver's selected route
  final List<String> _availableRoutes = const ['Route 7B', 'Route 12C', 'Airport Shuttle'];

  void _toggleSharing() {
    if (_selectedRoute == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a route first!')),
      );
      return;
    }

    final locationService = Provider.of<MockLocationService>(context, listen: false);
    setState(() {
      _isSharing = !_isSharing;
      if (_isSharing) {
        // Pass the selected route to the service
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('SELECT YOUR ROUTE', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey)),
              child: DropdownButton<String>(
                value: _selectedRoute,
                hint: const Text('Select Route'),
                isExpanded: true,
                underline: const SizedBox(),
                items: _availableRoutes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedRoute = newValue;
                  });
                },
              ),
            ),
            const SizedBox(height: 40),
            Icon(
              _isSharing ? Icons.location_on : Icons.location_off,
              size: 100,
              color: _isSharing ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              _isSharing ? 'Live Location Sharing is ON' : 'Live Location Sharing is OFF',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _toggleSharing,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isSharing ? Colors.red : Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              // THIS IS THE FIX: The child property was missing.
              child: Text(
                _isSharing ? 'Stop Sharing' : 'Start Sharing',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}