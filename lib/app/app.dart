import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:google_map_practice/features/map/view/map_view.dart';
import 'package:provider/provider.dart';

import '../features/map/view_model/location_view_model.dart';

class GoogleMap extends StatelessWidget {
  const GoogleMap({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocationViewModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Google Map",
        home: const MapView(),
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
      ),
    );
  }
}
