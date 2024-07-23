import 'dart:math';
import 'package:attendio_mobile/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  late GoogleMapController mapController;

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      location = "(${_currentPosition.latitude}, ${_currentPosition.longitude})";
    });
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
            const TextWidget(text: "Kota Jakarta Barat", type: 6),
            TextWidget(text: location, type: 5),
            mapWidget(size),
            SizedBox(height: 100),
            button()
          ],
        ),
      ),
    );
  }

  Widget button(String text, int index, int type) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SuccessPage()));
      },
      child: Container(
        height: 40,
        width: 200,
        decoration: BoxDecoration(
          color: type== 7? Colors.black : Colors.white,
          boxShadow: const [
            BoxShadow(
              offset: Offset(2, 3),
              color: Colors.grey,
              spreadRadius: 3,
              blurRadius: 2,
            ),
          ],
          borderRadius: BorderRadius.circular(15)
        ),
        child: Center(
          child: Text(text, style: TextStyles().getStyle(type))
        )
      )
    );
  }

  Widget mapWidget(Size size) {
    if (location.isEmpty) {
      return CircularProgressIndicator();
    } else {
      return SizedBox(
        height: min(0.7 * size.width, 0.4 * size.height),
        width: min(0.7 * size.width, 0.4 * size.height),
        child: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
            zoom: 11.0,
          ),
          markers: {
            Marker(
              markerId: MarkerId("My Location"),
              position: LatLng(_currentPosition.latitude, _currentPosition.longitude),
            ),
          },
        ),
      );
    }
  }
}
