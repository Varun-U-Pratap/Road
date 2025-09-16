// lib/mock_location_service.dart

import 'dart:async';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MockLocationService {
  final Map<String, StreamController<LatLng>> _locationStreamControllers = {};
  final Location _location = Location();
  
  // A timer to generate mock locations
  Timer? _mockLocationTimer;

  // This will now start a simulation instead of listening to the real GPS stream
  Future<void> startSharing(String routeId) async {
    _locationStreamControllers.putIfAbsent(routeId, () => StreamController.broadcast());

    // --- Permission checks to get the initial location ---
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

    // Stop any previous simulation
    stopSharing();

    // 1. Get the current location ONCE to use as a starting point
    LocationData initialLocation = await _location.getLocation();
    LatLng currentPosition = LatLng(initialLocation.latitude!, initialLocation.longitude!);

    // 2. Start a timer to simulate movement
    _mockLocationTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      // 3. Add a small offset to the coordinates to simulate movement
      currentPosition = LatLng(
        currentPosition.latitude + 0.0001, // Move North
        currentPosition.longitude + 0.0001, // Move East
      );

      // Add the new simulated position to the stream
      _locationStreamControllers[routeId]?.add(currentPosition);
    });
  }

  Stream<LatLng>? getStreamForRoute(String routeId) {
    _locationStreamControllers.putIfAbsent(routeId, () => StreamController.broadcast());
    return _locationStreamControllers[routeId]?.stream;
  }

  // This now stops the timer
  void stopSharing() {
    _mockLocationTimer?.cancel();
  }

  void dispose() {
    for (var controller in _locationStreamControllers.values) {
      controller.close();
    }
  }
}