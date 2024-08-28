import 'package:flutter/material.dart';
import 'package:google_map_practice/features/map/view_model/location_view_model.dart';

class CurrentLocationFinder extends StatelessWidget {
  final LocationViewModel locationViewModel;

  const CurrentLocationFinder({super.key, required this.locationViewModel});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 120,
      right: 10,
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          locationViewModel.navigateToCurrentLocation(
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
    );
  }
}
