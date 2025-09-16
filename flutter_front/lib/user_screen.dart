// lib/user_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mock_location_service.dart';

// New imports for OpenStreetMap
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Use this LatLng

class UserScreen extends StatefulWidget {
  final String routeId;
  const UserScreen({super.key, required this.routeId});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  Stream<LatLng>? _locationStream;
  final MapController _mapController = MapController(); // Controller for flutter_map

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locationService = Provider.of<MockLocationService>(context, listen: false);
    // The LatLng from our service is from latlong2, so no conversion needed
    _locationStream = locationService.getStreamForRoute(widget.routeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tracking: ${widget.routeId}')),
      body: StreamBuilder<LatLng>(
        stream: _locationStream,
        builder: (context, snapshot) {
          LatLng? busLocation;
          if (snapshot.hasData) {
            busLocation = snapshot.data;
            // Move the map to the new location
            _mapController.move(busLocation!, 15.0);
          }

          // The main map widget using flutter_map
          final flutterMap = FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(12.9716, 77.5946), // Bengaluru
              initialZoom: 12,
            ),
            children: [
              // The layer that shows the map background
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app', // Use your app's package name
              ),
              // The layer for the bus marker
              if (busLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: busLocation,
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.directions_bus,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ],
                ),
            ],
          );

          // Status indicator for when the bus is offline
          if (!snapshot.hasData) {
            return Stack(
              children: [
                flutterMap, // Show map in the background
                const Center(
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Waiting for bus location...\nThe bus may be offline.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return flutterMap;
        },
      ),
    );
  }
}