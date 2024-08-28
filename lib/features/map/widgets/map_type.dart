import 'package:flutter/material.dart';
import 'package:google_map_practice/features/map/view_model/location_view_model.dart';
import 'package:google_map_practice/utils/app_assets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';

class MapTypeSelector extends StatelessWidget {
  final LocationViewModel locationViewModel;

  const MapTypeSelector({super.key, required this.locationViewModel});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: 10,
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          locationViewModel.toggleMapTypeSelected();
        },
        child: AnimatedContainer(
          width: (!locationViewModel.isMapTypeSelected) ? 60 : 230,
          height: (!locationViewModel.isMapTypeSelected) ? 60 : 100,
          duration: const Duration(milliseconds: 400),
          alignment: Alignment.center,
          curve: Curves.fastOutSlowIn,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: FittedBox(
              child: getContainerChild(locationViewModel.isMapTypeSelected)),
        ),
      ),
    );
  }

  Widget getContainerChild(bool isMapTypeSelected) {
    if (!isMapTypeSelected) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.square_stack_3d_up)
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                locationViewModel.setMapType = MapType.normal;
                locationViewModel.toggleMapTypeSelected();
              },
              child: terrainOption(
                  mapTypeName: "Default", mapImage: AppAssets.normalMap),
            ),
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                locationViewModel.setMapType = MapType.satellite;
                locationViewModel.toggleMapTypeSelected();
              },
              child: terrainOption(
                  mapTypeName: "Satellite", mapImage: AppAssets.satelliteMap),
            ),
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                locationViewModel.toggleTrafficMode();
                locationViewModel.toggleMapTypeSelected();
              },
              child: terrainOption(
                  mapTypeName: "Traffic", mapImage: AppAssets.trafficMap),
            ),
          ],
        )
      ],
    );
  }

  Widget terrainOption({
    required String mapTypeName,
    required String mapImage,
  }) {
    return Container(
      width: 90,
      height: 90,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.fromBorderSide(getContainerBorder(mapTypeName)),
              image: DecorationImage(
                image: AssetImage(mapImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(mapTypeName)
        ],
      ),
    );
  }
  BorderSide getContainerBorder (String mapTypeName){
    if(mapTypeName == "Default" && locationViewModel.mapType == MapType.normal){
      return const BorderSide(color: Colors.blue,width: 2);
    }
    if(mapTypeName == "Satellite" && locationViewModel.mapType == MapType.satellite){
      return const BorderSide(color: Colors.blue,width: 2);
    }
    if(mapTypeName == "Traffic" && locationViewModel.showTraffic){
      return const BorderSide(color: Colors.blue,width: 2);
    }
    return const BorderSide(color: Colors.white);
  }
}
