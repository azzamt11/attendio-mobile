import 'package:attendio_mobile/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class RecognizedPage extends StatefulWidget {
  final String userId;
  final String userName;
  const RecognizedPage({super.key, required this.userId, required this.userName});

  @override
  State<RecognizedPage> createState() => _RecognizedPageState();
}

class _RecognizedPageState extends State<RecognizedPage> {
  String location = "";
  late Position _currentPosition;

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextWidget(text: "Welcome ${widget.userName}!", type: 4),
            const TextWidget(text: "Your location is", type: 5),
            TextWidget(text: location, type: 5),
            mapWidget()
          ],
        ),
      ),
    );
  }

  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, request the user to enable it.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, request again.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever.
      return Future.error('Location permissions are permanently denied.');
    }

    // Get the current position of the device.
    _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      location = "${_currentPosition.latitude}, ${_currentPosition.longitude}";
    });
  }

  Widget mapWidget() {
    if (location.isEmpty) {
      return CircularProgressIndicator();
    } else {
      final String googleMapUrl = 'https://www.google.com/maps?q=${_currentPosition.latitude},${_currentPosition.longitude}&z=15&output=embed';
      return Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              offset: Offset(2, 3),
              color: Colors.black12,
              spreadRadius: 3,
              blurRadius: 2,
            ),
          ],
        ),
        child: Container()
      );
    }
  }
}
