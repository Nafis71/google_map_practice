import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationViewModel extends ChangeNotifier {
  LatLng? _currentLocation;

  LatLng? get currentLocation => _currentLocation;

  Marker? _currentLocationMarker;

  Marker? get currentLocationMarker => _currentLocationMarker;
  List<LatLng> listOfLocations = [];

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

  void startLocationStream(GoogleMapController googleMapController) {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        timeLimit: Duration(
          seconds: 10,
        ),
      ),
    ).listen(
      (position) {
        _currentLocation = LatLng(position.latitude, position.longitude);
        listOfLocations.add(_currentLocation!);
        navigateToCurrentLocation(
          googleMapController: googleMapController,
          delayMarkerPosition: false,
        );
      },
    );
  }

  Future<void> navigateToCurrentLocation({
    required GoogleMapController googleMapController,
    required delayMarkerPosition,
  }) async {
    if (delayMarkerPosition) await Future.delayed(const Duration(seconds: 2));
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentLocation!,
          zoom: 16,
        ),
      ),
    );
    if (delayMarkerPosition) {
      await Future.delayed(const Duration(milliseconds: 900));
    }
    _currentLocationMarker = Marker(
        markerId: const MarkerId(
          "currentLocation",
        ),
        position: _currentLocation!,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
            title: "My Current Location", snippet: currentLocation.toString()));
    notifyListeners();
  }

  Future<void> checkLocationPermission() async {
    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.always ||
        locationPermission == LocationPermission.whileInUse) {
      return;
    }
    if (locationPermission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      checkLocationPermission();
      return;
    }
    await Geolocator.requestPermission();
    checkLocationPermission();
  }
}
