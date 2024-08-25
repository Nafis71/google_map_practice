import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationViewModel extends ChangeNotifier {
  LatLng? _currentLocation;

  LatLng? get currentLocation => _currentLocation;

  Marker? _currentLocationMarker;

  Marker? get currentLocationMarker => _currentLocationMarker;

  Future<void> loadCurrentLocation() async {
    await checkLocationPermission();
    final bool isEnable = await Geolocator.isLocationServiceEnabled();
    if (!isEnable) {
      await Geolocator.openLocationSettings();
    }
    Position currentPosition = await Geolocator.getCurrentPosition();
    _currentLocation =
        LatLng(currentPosition.latitude, currentPosition.longitude);
    notifyListeners();
  }

  Future<void> navigateToCurrentLocation(
      GoogleMapController googleMapController) async {
    await Future.delayed(const Duration(seconds: 2));
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentLocation!,
          zoom: 16,
        ),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 900));
    _currentLocationMarker = Marker(
      markerId: const MarkerId(
        "currentLocation",
      ),
      position: _currentLocation!,
      icon: BitmapDescriptor.defaultMarker
    );
    notifyListeners();
  }

  Future<void> checkLocationPermission() async {
    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.deniedForever ||
        locationPermission == LocationPermission.denied) {
      await Geolocator.openAppSettings();
      checkLocationPermission();
    }
    if (locationPermission == LocationPermission.always ||
        locationPermission == LocationPermission.whileInUse) {
      return;
    }
    await Geolocator.requestPermission();
  }
}
