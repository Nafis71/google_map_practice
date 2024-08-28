import 'package:flutter/material.dart';
import 'package:google_map_practice/features/map/view_model/location_view_model.dart';

class MapZoomer extends StatelessWidget {
  final LocationViewModel locationViewModel;

  const MapZoomer({super.key, required this.locationViewModel});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 180,
      right: 15,
      child: Column(
        children: <Widget>[
          InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                locationViewModel.zoomIn();
              },
              child: zoomButton(Icons.add)),
          const SizedBox(
            height: 7,
          ),
          InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                locationViewModel.zoomOut();
              },
              child: zoomButton(Icons.remove)),
        ],
      ),
    );
  }

  Widget zoomButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
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
      child: Icon(icon),
    );
  }
}
