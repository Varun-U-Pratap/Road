// lib/mock_location_service.dart

import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

// This class will act as our fake backend service
class MockLocationService {
  // A stream that emits the bus's location.
  final StreamController<LatLng> _locationStreamController = StreamController.broadcast();
  Stream<LatLng> get locationStream => _locationStreamController.stream;

  StreamSubscription<LocationData>? _locationSubscription;
  final Location _location = Location();

  // Method for the driver to start sharing their location
  Future<void> startSharing() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // Listen to real location changes
    _locationSubscription = _location.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        // Add the new location to our stream for the user to see
        _locationStreamController.add(LatLng(currentLocation.latitude!, currentLocation.longitude!));
      }
    });
  }

  // Method for the driver to stop sharing
  void stopSharing() {
    _locationSubscription?.cancel();
  }

  // Close the stream when the service is no longer needed
  void dispose() {
    _locationStreamController.close();
  }
}