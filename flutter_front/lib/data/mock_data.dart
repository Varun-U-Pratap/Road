// lib/data/mock_data.dart

import 'package:latlong2/latlong.dart';

class BusStop {
  final String name;
  final LatLng position;
  BusStop({required this.name, required this.position});
}

class BusRoute {
  final String routeName;
  final String busId;
  final List<BusStop> stops;
  final List<LatLng> path;
  BusRoute({required this.routeName, required this.busId, required this.stops, required this.path});
}

// Updated mock data with detailed, road-following paths
final List<BusRoute> mockRoutes = [
  BusRoute(
    routeName: '500D - Hebbal to Silk Board',
    busId: '500D - Hebbal to Silk Board',
    stops: [
      BusStop(name: 'Hebbal', position: LatLng(13.0359, 77.5971)),
      BusStop(name: 'Mekhri Circle', position: LatLng(13.0125, 77.5879)),
      BusStop(name: 'KBS (Majestic)', position: LatLng(12.9767, 77.5713)),
      BusStop(name: 'Shantinagar Bus Station', position: LatLng(12.9599, 77.5978)),
      BusStop(name: 'Silk Board', position: LatLng(12.9172, 77.6238)),
    ],
    path: [
      LatLng(13.0359, 77.5971), // Hebbal
      LatLng(13.0252, 77.5932),
      LatLng(13.0125, 77.5879), // Mekhri Circle
      LatLng(13.0042, 77.5845),
      LatLng(12.9890, 77.5820),
      LatLng(12.9767, 77.5713), // KBS (Majestic)
      LatLng(12.9722, 77.5786),
      LatLng(12.9688, 77.5843),
      LatLng(12.9645, 77.5931),
      LatLng(12.9599, 77.5978), // Shantinagar
      LatLng(12.9472, 77.5999),
      LatLng(12.9325, 77.6094),
      LatLng(12.9172, 77.6238), // Silk Board
    ],
  ),
  BusRoute(
    routeName: '335E - Majestic to ITPL',
    busId: '335E - Majestic to ITPL',
    stops: [
      BusStop(name: 'KBS (Majestic)', position: LatLng(12.9767, 77.5713)),
      BusStop(name: 'MG Road Metro', position: LatLng(12.9759, 77.6063)),
      BusStop(name: 'Tin Factory', position: LatLng(12.9912, 77.6621)),
      BusStop(name: 'Marathahalli', position: LatLng(12.9592, 77.7013)),
      BusStop(name: 'ITPL', position: LatLng(12.9860, 77.7490)),
    ],
    path: [
      LatLng(12.9767, 77.5713), // KBS (Majestic)
      LatLng(12.9760, 77.5891),
      LatLng(12.9759, 77.6063), // MG Road
      LatLng(12.9790, 77.6390),
      LatLng(12.9912, 77.6621), // Tin Factory
      LatLng(12.9858, 77.6750),
      LatLng(12.9750, 77.6850),
      LatLng(12.9592, 77.7013), // Marathahalli
      LatLng(12.9698, 77.7251),
      LatLng(12.9860, 77.7490), // ITPL
    ],
  ),
  BusRoute(
    routeName: 'KIAS-9 - Majestic to Airport',
    busId: 'KIAS-9 - Majestic to Airport',
    stops: [
      BusStop(name: 'KBS (Majestic)', position: LatLng(12.9767, 77.5713)),
      BusStop(name: 'Mekhri Circle', position: LatLng(13.0125, 77.5879)),
      BusStop(name: 'Hebbal', position: LatLng(13.0359, 77.5971)),
      BusStop(name: 'Kempegowda Int\'l Airport', position: LatLng(13.1986, 77.7066)),
    ],
    path: [
      LatLng(12.9767, 77.5713), // KBS (Majestic)
      LatLng(12.9940, 77.5835),
      LatLng(13.0125, 77.5879), // Mekhri Circle
      LatLng(13.0359, 77.5971), // Hebbal
      LatLng(13.0781, 77.6252),
      LatLng(13.1189, 77.6533),
      LatLng(13.1500, 77.6600),
      LatLng(13.1793, 77.6879),
      LatLng(13.1986, 77.7066), // Airport
    ],
  ),
];