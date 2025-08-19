import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FactoryMapPage extends StatefulWidget {
  const FactoryMapPage({Key? key}) : super(key: key);

  @override
  _FactoryMapPageState createState() => _FactoryMapPageState();
}

class _FactoryMapPageState extends State<FactoryMapPage> {
  late final LatLng _randomPos;

  @override
  void initState() {
    super.initState();
    _randomPos = _getRandomLocation();
  }

  LatLng _getRandomLocation() {
    final rand = Random();
    const latMin = 36.0, latMax = 42.0;
    const lngMin = 26.0, lngMax = 45.0;
    final lat = latMin + rand.nextDouble() * (latMax - latMin);
    final lng = lngMin + rand.nextDouble() * (lngMax - lngMin);
    return LatLng(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Factory Layout')),
      body: Center(
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 8,
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _randomPos,
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('factory'),
                        position: _randomPos,
                        infoWindow: const InfoWindow(title: 'Random Factory'),
                      ),
                    },
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    liteModeEnabled: true,
                  ),

                  _fancyRoom(
                    icon: Icons.business,
                    label: 'Office A',
                    alignment: const FractionalOffset(0.1, 0.1),
                  ),
                  _fancyRoom(
                    icon: Icons.business_center,
                    label: 'Office B',
                    alignment: const FractionalOffset(0.9, 0.1),
                  ),
                  _fancyRoom(
                    icon: Icons.restaurant,
                    label: 'Cafeteria',
                    alignment: const FractionalOffset(0.1, 0.9),
                    width: 140,
                    height: 70,
                  ),
                  _fancyRoom(
                    icon: Icons.meeting_room,
                    label: 'Meeting\nRoom',
                    alignment: const FractionalOffset(0.9, 0.9),
                  ),
                  _fancyRoom(
                    icon: Icons.exit_to_app,
                    label: 'Entrance',
                    alignment: const FractionalOffset(0.5, 0.5),
                    width: 120,
                    height: 60,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _fancyRoom({
    required IconData icon,
    required String label,
    required FractionalOffset alignment,
    double width = 110,
    double height = 50,
  }) {
    return Align(
      alignment: alignment,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: Colors.grey.shade800),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
