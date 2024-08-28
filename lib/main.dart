import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:google_map_practice/app/app.dart';

void main() {
  runApp(DevicePreview(builder: (_)=> const GoogleMap()));
}
