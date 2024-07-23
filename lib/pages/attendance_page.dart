import 'dart:io';

import 'package:attendio_mobile/helpers/text_styles.dart';
import 'package:attendio_mobile/pages/camera_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {

  @override
  Widget build(BuildContext context) {
    var size= MediaQuery.of(context).size;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: Container(
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              button("Scan Wajah", 0, 8),
              const SizedBox(height: 30),
              button("Register", 1, 7),
            ],
          ),
        ),
      ),
    );
  }

  Widget button(String text, int index, int type) {
    return GestureDetector(
      onTap: () {
        redirectFunction(index);
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

  Future<void> redirectFunction(int index) async {

    if (index==0) {
      if(!context.mounted) {
      return;
      }

      final cameras = await availableCameras();
      final firstCamera = cameras.length> 1? cameras[1] : cameras.first;
      Navigator.push(context, MaterialPageRoute(builder: (context)=> CameraPage(camera: firstCamera)));

    } else {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fitur ini belum tersedia, karena backend belum ada'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

}