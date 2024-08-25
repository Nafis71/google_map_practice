import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationViewModel extends ChangeNotifier{
  LatLng? _currentLocation;

  LatLng? get currentLocation => _currentLocation;

  Future<void> loadCurrentLocation() async {
    bool serviceEnabled;

  }
}