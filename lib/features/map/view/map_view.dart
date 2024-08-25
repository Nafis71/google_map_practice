import 'package:flutter/material.dart';
import 'package:google_map_practice/utils/app_assets.dart';
import 'package:google_map_practice/wrappers/animation_loader.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../view_model/location_view_model.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController _googleMapController;

  @override
  void initState() {
    super.initState();
    context.read<LocationViewModel>().loadCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Google Map",
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Consumer<LocationViewModel>(
        builder: (_, locationController, __) {
          if (locationController.currentLocation == null) {
            return const Center(
              child: AnimationLoader(
                assetName: AppAssets.gpsAnimation,
                boxFit: BoxFit.contain,
              ),
            );
          }
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: const CameraPosition(
              target: LatLng(24.667710, 78.070819),
              zoom: 0,
            ),
            trafficEnabled: false,
            onMapCreated: (GoogleMapController controller) async {
              _googleMapController = controller;
              locationController.navigateToCurrentLocation(
                googleMapController: _googleMapController,
                delayMarkerPosition: true,
              );
              await Future.delayed(const Duration(seconds: 3));
              locationController.startLocationStream(_googleMapController);
            },
            markers: {
              if (locationController.currentLocationMarker != null)
                locationController.currentLocationMarker!
            },
            polylines: {
              Polyline(
                  polylineId: const PolylineId("navigation"),
                  points: locationController.listOfLocations,
                  color: Colors.blue.shade300,
                  width: 5,
                  jointType: JointType.round,
                  geodesic: true),
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }
}
