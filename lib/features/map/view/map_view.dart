import 'package:flutter/material.dart';
import 'package:google_map_practice/features/map/widgets/current_location_finder.dart';
import 'package:google_map_practice/features/map/widgets/footer_widget.dart';
import 'package:google_map_practice/features/map/widgets/map_type.dart';
import 'package:google_map_practice/features/map/widgets/map_widget.dart';
import 'package:google_map_practice/features/map/widgets/map_zoomer.dart';
import 'package:google_map_practice/utils/app_assets.dart';
import 'package:google_map_practice/wrappers/animation_loader.dart';
import 'package:provider/provider.dart';

import '../view_model/location_view_model.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
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
        backgroundColor: const Color(0xFF4770A2),
      ),
      body: Consumer<LocationViewModel>(
        builder: (_, locationViewModel, __) {
          if (locationViewModel.currentLocation == null) {
            return const Center(
              child: AnimationLoader(
                assetName: AppAssets.gpsAnimation,
                boxFit: BoxFit.contain,
              ),
            );
          }
          return Stack(
            children: [
              MapWidget(
                locationViewModel: locationViewModel,
              ),
              MapTypeSelector(locationViewModel: locationViewModel),
              MapZoomer(locationViewModel: locationViewModel),
              CurrentLocationFinder(locationViewModel: locationViewModel),
              FooterWidget(locationViewModel: locationViewModel),
            ],
          );
        },
      ),
    );
  }
}
