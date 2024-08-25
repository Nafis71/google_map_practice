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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Google Map"),
      ),
      body: Consumer<LocationViewModel>(builder: (_, locationController, __) {
        if (locationController.currentLocation == null) {
          // return const Center(
          //   child: AnimationLoader(
          //     assetName: AppAssets.gpsAnimation,
          //     boxFit: BoxFit.contain,
          //   ),
          // );
        }
        return GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: const CameraPosition(
            target: LatLng(24.667710, 78.070819),
            zoom: 0,
          ),
          trafficEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _googleMapController = controller;
          },
          markers: {
            // Marker(
            //   markerId: const MarkerId("current_location"),
            //   icon: BitmapDescriptor.defaultMarker,
            //   position: currentLocation ?? const LatLng(24.667710, 78.070819)
            // ),
          },
        );
      }),
    );
  }
}
