import 'package:flutter/material.dart';
import 'package:google_map_practice/features/map/view_model/location_view_model.dart';

class FooterWidget extends StatelessWidget {
  final LocationViewModel locationViewModel;

  const FooterWidget({super.key, required this.locationViewModel});

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              "${locationViewModel.currentSpeed.toStringAsFixed(2)} Km/h",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
