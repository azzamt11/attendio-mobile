import 'package:attendio_mobile/pages/camera_page.dart';
import 'package:attendio_mobile/widget/text_widget.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';


class InitialPage extends StatefulWidget {
  final CameraDescription camera;
  const InitialPage({Key? key, required this.camera}) : super(key: key);

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  double targetOpacity= 0;

  @override
  void initState() {
    initiate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: getBody(size),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget getBody(var size) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromRGBO(255, 255, 255, 1), Color.fromRGBO(0, 0, 0, 0.5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.4, 0.7],
          tileMode: TileMode.repeated,
        ),
      ),
      child: Stack(
        children: [
          Center(child: logoWidget(size)),
          appName(),
        ],
      ),
    );
  }

  Widget logoWidget(var size) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1700),
      builder: (BuildContext context, double opacity, Widget? child) {
        return Opacity(
          opacity: opacity,
          child: Container(
            height: 180,
            width: 180,
            margin: const EdgeInsets.only(bottom: 35),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/logo.png"),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget appName() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: targetOpacity),
          duration: const Duration(milliseconds: 1700),
          builder: (BuildContext context, double opacity, Widget? child) {
            return Opacity(
              opacity: opacity,
              child: const SizedBox(
                height: 50,
                child: Column(
                  children: [
                    TextWidget(text: "Todo Mobile", type: 1),
                    TextWidget(text: "Version 1.0.0", type: 1),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> initiate() async{
    setState(() {
      targetOpacity= 1;
    });
    await Future.delayed(const Duration(milliseconds: 3000));
    if(!context.mounted) {
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context)=> CameraPage(camera: widget.camera)));
  }
}