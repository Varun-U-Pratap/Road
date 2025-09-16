// lib/user_screen.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'mock_location_service.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  GoogleMapController? _mapController;
  Marker? _busMarker;

  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(12.9716, 77.5946), // Bengaluru, India
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    // Access the location service from the provider
    final locationService = Provider.of<MockLocationService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Live Bus Tracker')),
      body: StreamBuilder<LatLng>(
        stream: locationService.locationStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final LatLng busLocation = snapshot.data!;
            // Update the marker with the new location
            _busMarker = Marker(
              markerId: const MarkerId('bus'),
              position: busLocation,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
              infoWindow: const InfoWindow(title: 'Bus Location')
            );
            // Animate camera to the bus
            _mapController?.animateCamera(CameraUpdate.newLatLng(busLocation));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
             // You can show a loading indicator here if needed
          }

          return GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _mapController = controller,
            markers: _busMarker != null ? {_busMarker!} : {},
          );
        },
      ),
    );
  }
}