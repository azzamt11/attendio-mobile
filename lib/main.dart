import 'package:attendio_mobile/pages/initial_page.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(const MaterialApp(
    home: InitialPage(),
    debugShowCheckedModeBanner: false,
  ));
}