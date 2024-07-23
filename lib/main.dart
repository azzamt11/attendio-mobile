import 'package:attendio_mobile/pages/initial_page.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MaterialApp(
    home: InitialPage(),
    debugShowCheckedModeBanner: false,
  ));
}