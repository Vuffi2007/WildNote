import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:wild_note/colors.dart';
import 'package:hive/hive.dart';
import 'package:wild_note/my_flutter_app_icons.dart';
import '../fish.dart';



late Box<Fish> fishBox;

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    fishBox = Hive.box<Fish>('fishBox');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
      future: _determinePosition(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final currentPosition = snapshot.data!;

        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: LatLng(
              currentPosition.latitude,
              currentPosition.longitude,
            ),
            initialZoom: 16,
          ),

          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: '********',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(currentPosition.latitude, currentPosition.longitude),
                  width: 38,
                  height: 38,
                  child: CircleAvatar(
                    backgroundColor: blueFishColorScheme.primary,
                    child: Icon(
                      Icons.man,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                ..._buildFishMarkers(),
              ],
            ),
          ],
        );
      },
    );
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permissions are permanently denied');
  }

  return await Geolocator.getCurrentPosition();
}

List<Marker> _buildFishMarkers() {
  return fishBox.values.map((fish) {
    return Marker(
      point: LatLng(fish.latitude, fish.longitude),
      width: 40,
      height: 40,
      child: Icon(
        MyFlutterApp.fish, // or any icon you like
        color: Colors.orange,
        size: 30,
      ),
    );
  }).toList();
}
