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

  void _toggleSharing() {
    final locationService = Provider.of<MockLocationService>(context, listen: false);
    setState(() {
      _isSharing = !_isSharing;
      if (_isSharing) {
        locationService.startSharing();
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