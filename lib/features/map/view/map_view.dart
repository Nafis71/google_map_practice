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
          "Real Time Location Tracker",
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
          return Stack(
            children: [
              GoogleMap(
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(24.667710, 78.070819),
                  zoom: 0,
                ),
                onCameraMove: (CameraPosition cameraPosition) {
                  locationController.setMapZoom = cameraPosition.zoom;
                },
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
                myLocationEnabled: false,
                myLocationButtonEnabled: true,
              ),
              Positioned(
                bottom: 120,
                right: 10,
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    locationController.navigateToCurrentLocation(
                      googleMapController: _googleMapController,
                      delayMarkerPosition: false,
                    );
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.navigation_rounded,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  padding: const EdgeInsets.only(top: 30, left: 30),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Your current speed",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        "${locationController.currentSpeed.toStringAsFixed(2)} Km/h",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
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
