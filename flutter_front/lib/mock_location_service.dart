// lib/mock_location_service.dart

import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MockLocationService {
  // We now use a Map to manage a stream for each bus/route ID.
  final Map<String, StreamController<LatLng>> _locationStreamControllers = {};
  StreamSubscription<LocationData>? _locationSubscription;
  final Location _location = Location();

  // The driver's app calls this, specifying which route it's on.
  Future<void> startSharing(String routeId) async {
    // Ensure a stream controller exists for this route.
    _locationStreamControllers.putIfAbsent(routeId, () => StreamController.broadcast());

    // --- Permission checks remain the same ---
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
    // --- End of permission checks ---

    // Cancel any existing subscription before starting a new one.
    _locationSubscription?.cancel();

    _locationSubscription = _location.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        final newPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        // Add the new location to the specific stream for the given route.
        _locationStreamControllers[routeId]?.add(newPosition);
      }
    });
  }

  // The user's app calls this to listen to a specific route.
  Stream<LatLng>? getStreamForRoute(String routeId) {
    // Ensure a stream controller exists before returning the stream.
    _locationStreamControllers.putIfAbsent(routeId, () => StreamController.broadcast());
    return _locationStreamControllers[routeId]?.stream;
  }

  // Stop sharing location.
  void stopSharing() {
    _locationSubscription?.cancel();
  }

  void dispose() {
    // Close all stream controllers when the service is disposed.
    for (var controller in _locationStreamControllers.values) {
      controller.close();
    }
  }
}