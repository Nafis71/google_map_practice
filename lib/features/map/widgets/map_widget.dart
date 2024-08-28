import 'package:flutter/material.dart';
import 'package:google_map_practice/features/map/view_model/location_view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  final LocationViewModel locationViewModel;

  const MapWidget({
    super.key,
    required this.locationViewModel,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late GoogleMapController _googleMapController;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      zoomControlsEnabled: false,
      mapType: widget.locationViewModel.mapType,
      initialCameraPosition: const CameraPosition(
        target: LatLng(24.667710, 78.070819),
        zoom: 0,
      ),
      onCameraMove: (CameraPosition cameraPosition) {
        widget.locationViewModel.setMapZoom = cameraPosition.zoom;
      },
      onTap: (position){
        widget.locationViewModel.disableMapSelection();
      },
      trafficEnabled: widget.locationViewModel.showTraffic,
      onMapCreated: (GoogleMapController controller) async {
        _googleMapController = controller;
        widget.locationViewModel.navigateToCurrentLocation(
          googleMapController: _googleMapController,
          delayMarkerPosition: true,
        );
        await Future.delayed(const Duration(seconds: 3));
        widget.locationViewModel.startLocationStream(_googleMapController);
      },
      markers: {
        if (widget.locationViewModel.currentLocationMarker != null)
          widget.locationViewModel.currentLocationMarker!
      },
      polylines: {
        Polyline(
          polylineId: const PolylineId("navigation"),
          points: widget.locationViewModel.listOfLocations,
          color: Colors.blue.shade300,
          width: 5,
          jointType: JointType.round,
          geodesic: true,
        ),
      },
      myLocationEnabled: false,
      myLocationButtonEnabled: true,
    );
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }
}
