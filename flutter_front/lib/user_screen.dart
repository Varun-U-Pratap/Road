// lib/user_screen.dart

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'mock_location_service.dart';
import 'data/mock_data.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:simple_animations/simple_animations.dart';

// Weather Model
class Weather {
  final String description;
  final String icon;
  Weather({required this.description, required this.icon});
}

class UserScreen extends StatefulWidget {
  final String routeId;
  const UserScreen({super.key, required this.routeId});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> with TickerProviderStateMixin {
  late final BusRoute selectedRoute;
  late final Stream<LatLng> _locationStream;
  final MapController _mapController = MapController();

  bool _isRideAlongMode = false;
  Future<Weather>? _weatherFuture;

  @override
  void initState() {
    super.initState();
    selectedRoute = mockRoutes.firstWhere((r) => r.busId == widget.routeId);
    final locationService = Provider.of<MockLocationService>(context, listen: false);
    _locationStream = locationService.getStreamForRoute(widget.routeId)!;
    _weatherFuture = _fetchWeather();
  }

  Future<Weather> _fetchWeather() async {
    const apiKey = 'YOUR_OPENWEATHERMAP_API_KEY'; // Get a free key from OpenWeatherMap
    const lat = 12.9716; // Bengaluru Lat
    const lon = 77.5946; // Bengaluru Lon
    final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Weather(
          description: data['weather'][0]['main'],
          icon: data['weather'][0]['icon'],
        );
      }
    } catch (e) { /* Fallback */ }
    return Weather(description: 'Clear', icon: '01d');
  }

  void _toggleRideAlongMode() {
    setState(() {
      _isRideAlongMode = !_isRideAlongMode;
    });
  }

  // THIS IS THE CORRECT, UNIFIED BUILD METHOD
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Hero(
          tag: 'route_name_${selectedRoute.busId}',
          child: Material(
            color: Colors.transparent,
            child: Text(selectedRoute.routeName, style: theme.textTheme.titleLarge),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: theme.colorScheme.surface.withOpacity(0.8),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
      body: SlidingUpPanel(
        minHeight: 200,
        maxHeight: MediaQuery.of(context).size.height * 0.6,
        parallaxEnabled: true,
        parallaxOffset: 0.1,
        panelBuilder: (sc) => ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: theme.colorScheme.surface.withOpacity(0.8),
              child: _buildPanelContent(sc),
            ),
          ),
        ),
        body: _buildMap(),
        color: Colors.transparent,
        boxShadow: const [],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleRideAlongMode,
        backgroundColor: _isRideAlongMode ? theme.colorScheme.secondary : theme.colorScheme.primary,
        child: Icon(_isRideAlongMode ? Icons.location_searching : Icons.navigation),
      ),
    );
  }


  Widget _buildMap() {
    // ... (This function remains the same as before)
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: selectedRoute.stops.first.position,
        initialZoom: 14,
        initialCamera: CameraFit.bounds(
          bounds: LatLngBounds.fromPoints(selectedRoute.path),
          padding: const EdgeInsets.all(50.0),
        ).fit(const CameraOptions(
          rotation: -15.0,
        )),
      ),
      children: [
        FutureBuilder<Weather>(
          future: _weatherFuture,
          builder: (context, snapshot) {
            String mapStyle = 'dark_all';
            if (snapshot.hasData) {
              if (snapshot.data!.description.contains('Rain')) {
                mapStyle = 'dark_all';
              } else if (snapshot.data!.icon.contains('n')) {
                mapStyle = 'dark_all';
              } else {
                mapStyle = 'rastertiles/voyager';
              }
            }
            return TileLayer(
              urlTemplate: 'https://{s}.basemaps.cartocdn.com/$mapStyle/{z}/{x}/{y}{r}.png',
              subdomains: const ['a', 'b', 'c', 'd'],
              userAgentPackageName: 'com.sih.livetrack', // Use your package name
            );
          },
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: selectedRoute.path,
              strokeWidth: 5,
              gradientColors: [Colors.white.withOpacity(0.1), Colors.tealAccent.withOpacity(0.8)],
            ),
          ],
        ),
        MarkerLayer(
          markers: selectedRoute.stops.map((stop) {
            return Marker(
              point: stop.position,
              width: 100,
              height: 100,
              child: const Icon(Icons.location_on, color: Colors.redAccent, size: 30),
            );
          }).toList(),
        ),
        StreamBuilder<LatLng>(
          stream: _locationStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            final busLocation = snapshot.data!;
            if (_isRideAlongMode) {
              // Note: True bearing calculation is more complex, this is a simplified move.
              _mapController.move(busLocation, 16);
            }
            return MarkerLayer(
              markers: [
                Marker(
                  point: busLocation,
                  width: 120,
                  height: 120,
                  child: _buildBusMarker(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildBusMarker() {
     // ... (This function remains the same as before)
     return PlayAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.2),
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      delay: Duration.zero,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.directions_bus, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }

  Widget _buildPanelContent(ScrollController sc) {
    // ... (This function remains the same as before)
     final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 5, margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(color: Colors.grey[500], borderRadius: BorderRadius.circular(12)),
            ),
          ),
          Text(
            'Stops & Arrival Times',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<LatLng>(
              stream: _locationStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final busLocation = snapshot.data!;
                
                return ListView.separated(
                  controller: sc,
                  itemCount: selectedRoute.stops.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.white24),
                  itemBuilder: (context, index) {
                    final stop = selectedRoute.stops[index];
                    final distance = Distance();
                    final double distanceInMeters = distance(busLocation, stop.position);
                    const double averageSpeedMps = 7.0;
                    final int etaMinutes = (distanceInMeters / averageSpeedMps / 60).ceil();

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                        child: Icon(Icons.flag, color: theme.colorScheme.primary),
                      ),
                      title: Text(stop.name, style: theme.textTheme.bodyLarge),
                      trailing: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                        child: Text(
                          '$etaMinutes min',
                          key: ValueKey<int>(etaMinutes),
                          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}