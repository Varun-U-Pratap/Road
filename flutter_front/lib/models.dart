// You can create a new file like 'lib/models.dart'

import 'package:latlong2/latlong.dart';

class BusStop {
  final String name;
  final LatLng position;

  BusStop({required this.name, required this.position});
}

class BusRoute {
  final String routeName;
  final String busId; // e.g., 'KA-01-F-1234'
  final List<BusStop> stops;
  final List<LatLng> path; // The points for drawing the polyline

  BusRoute({
    required this.routeName,
    required this.busId,
    required this.stops,
    required this.path,
  });
}

// Create some mock data for your prototype
final mockRoutes = [
  BusRoute(
    routeName: 'Route 7B',
    busId: 'Route 7B', // Use the route name as ID for the mock service
    stops: [
      BusStop(name: 'Majestic Station', position: LatLng(12.9767, 77.5713)),
      BusStop(name: 'Corporation Circle', position: LatLng(12.9688, 77.5843)),
      BusStop(name: 'Shantinagar Bus Station', position: LatLng(12.9599, 77.5978)),
    ],
    path: [ // Points for the Polyline
      LatLng(12.9767, 77.5713),
      LatLng(12.9720, 77.5780),
      LatLng(12.9688, 77.5843),
      LatLng(12.9630, 77.5920),
      LatLng(12.9599, 77.5978),
    ],
  ),
  // Add another route for selection
];