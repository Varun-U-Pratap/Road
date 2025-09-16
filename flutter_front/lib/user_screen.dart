// lib/user_screen.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'mock_location_service.dart';

class UserScreen extends StatefulWidget {
  // Accept the routeId from the selection screen
  final String routeId;
  const UserScreen({super.key, required this.routeId});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  GoogleMapController? _mapController;
  Marker? _busMarker;
  Stream<LatLng>? _locationStream; // The stream for our specific route

  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(12.9716, 77.5946), // Bengaluru
    zoom: 12,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the stream for the specific route passed to this widget
    final locationService = Provider.of<MockLocationService>(context, listen: false);
    _locationStream = locationService.getStreamForRoute(widget.routeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tracking: ${widget.routeId}')),
      body: StreamBuilder<LatLng>(
        stream: _locationStream,
        builder: (context, snapshot) {
          // If we have data, update the marker
          if (snapshot.hasData) {
            final LatLng busLocation = snapshot.data!;
            _busMarker = Marker(
              markerId: MarkerId(widget.routeId),
              position: busLocation,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            );
            _mapController?.animateCamera(CameraUpdate.newLatLng(busLocation));
          }

          // The core map widget
          final googleMap = GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _mapController = controller,
            markers: _busMarker != null ? {_busMarker!} : {},
          );

          // NEW FEATURE: Status Indicator
          // If there's no data, show an overlay message
          if (!snapshot.hasData) {
            return Stack(
              children: [
                googleMap, // Show map in the background
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
          // Otherwise, just show the map with the updated marker
          return googleMap;
        },
      ),
    );
  }
}