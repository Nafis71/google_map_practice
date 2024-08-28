import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_practice/utils/app_assets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationViewModel extends ChangeNotifier {
  LatLng? _currentLocation;
  LatLng? _previousLocation;
  double _mapZoom = 16;
  double _currentSpeed = 0;
  List<LatLng> listOfLocations = [];
  MapType _mapType = MapType.normal;
  Marker? _currentLocationMarker;
  late GoogleMapController _googleMapController;
  bool _isMapTypeSelected = false;
  bool _showTraffic = false;

  LatLng? get currentLocation => _currentLocation;

  Marker? get currentLocationMarker => _currentLocationMarker;

  double get currentSpeed => _currentSpeed;

  bool get isMapTypeSelected => _isMapTypeSelected;

  bool get showTraffic => _showTraffic;

  MapType get mapType => _mapType;

  set setMapZoom(double zoom) {
    _mapZoom = zoom;
  }

  set setMapType(MapType mapType) {
    _mapType = mapType;
  }

  void toggleTrafficMode() {
    _showTraffic = !_showTraffic;
  }

  void toggleMapTypeSelected() {
    _isMapTypeSelected = !_isMapTypeSelected;
    notifyListeners();
  }

  void disableMapSelection() {
    _isMapTypeSelected = false;
    notifyListeners();
  }

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

  Future<void> startLocationStream(
      GoogleMapController googleMapController) async {
    try {
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
          if (_previousLocation != null) {
            if (_previousLocation!.latitude == _currentLocation!.latitude &&
                _previousLocation!.longitude == _currentLocation!.longitude) {
              _currentSpeed = 0.00;
              notifyListeners();
              return;
            } else {
              _currentSpeed = (position.speed * 3600) / 1000;
            }
          }
          _previousLocation = _currentLocation;
          navigateToCurrentLocation(
            googleMapController: googleMapController,
            delayMarkerPosition: false,
          );
        },
      ).onError((handleError) async {
        if (!await Geolocator.isLocationServiceEnabled()) {
          await Geolocator.openLocationSettings();
        }
        startLocationStream(googleMapController);
      });
    } catch (exception) {
      if (kDebugMode) {
        debugPrint(exception.toString());
      }
    }
  }

  Future<void> navigateToCurrentLocation({
    GoogleMapController? googleMapController,
    required delayMarkerPosition,
  }) async {
    if (delayMarkerPosition) {
      _googleMapController = googleMapController!;
      await Future.delayed(const Duration(seconds: 2));
      _mapZoom = 16;
    }
    _googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentLocation!,
          zoom: _mapZoom,
        ),
      ),
    );
    if (delayMarkerPosition) {
      await Future.delayed(
        const Duration(milliseconds: 900),
      );
    }
    await updateLocationMarker();
    notifyListeners();
  }

  Future<void> updateLocationMarker() async {
    _currentLocationMarker = Marker(
      markerId: const MarkerId(
        "currentLocation",
      ),
      position: _currentLocation!,
      icon: await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(40, 40), devicePixelRatio: 1),
        AppAssets.customMapMarker,
      ),
      infoWindow: InfoWindow(
        title: "My Current Location",
        snippet: currentLocation.toString(),
      ),
    );
  }

  void zoomIn() {
    _googleMapController.animateCamera(CameraUpdate.zoomIn());
  }

  void zoomOut() {
    _googleMapController.animateCamera(CameraUpdate.zoomOut());
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
