// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({Key? key}) : super(key: key);

  @override
  State<SuccessPage> createState() => _ThankYouPageState();
}

Color themeColor = Color.fromARGB(255, 3, 8, 6);

class _ThankYouPageState extends State<SuccessPage> {
  double screenWidth = 600;
  double screenHeight = 400;
  Color textColor = Color.fromARGB(255, 4, 33, 62);

  @override
  void initState() {
    goBackToHomeInFewSeconds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 170,
              padding: EdgeInsets.all(35),
              decoration: BoxDecoration(
                color: themeColor,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                "assets/attendance.png",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: screenHeight * 0.1),
            Text(
              "Thank You!",
              style: TextStyle(
                color: themeColor,
                fontWeight: FontWeight.w600,
                fontSize: 36,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              "Sukses Mengumpulkan Absen",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                fontSize: 17,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Text(
              "Anda akan dialihkan ke halaman home dalam beberapa saat lagi",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            SizedBox(height: screenHeight * 0.06)
          ],
        ),
      ),
    );
  }

  Future<void> goBackToHomeInFewSeconds() async{
    await Future.delayed(const Duration(milliseconds: 5000));
    if(!context.mounted) {
      return;
    }
    for(int i=0; i< 3; i++) {Navigator.of(context).pop();}
  }
}