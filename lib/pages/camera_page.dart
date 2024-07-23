import 'package:attendio_mobile/pages/recognized_page.dart';
import 'package:attendio_mobile/utils/face_recognition.dart';
import 'package:attendio_mobile/widget/text_widget.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class CameraPage extends StatefulWidget {
  final CameraDescription camera;

  const CameraPage({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late FaceRecognition _faceRecognition;
  bool _isRecognized = false;
  String _userId= "0";
  String _userName= "undefined";
  List<Face> _faces = [];

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
    _faceRecognition = FaceRecognition();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _processImage(InputImage inputImage, Size size) async {
    final faceDetector = GoogleMlKit.vision.faceDetector();
    final faces = await faceDetector.processImage(inputImage);

    for (final face in faces) {
      final result = await _faceRecognition.recognizeFace(face)??["0", "undefined"];
      setState(() {
        _isRecognized = result[0] != null;
        _userName = result[1]??"undefined";
        _userId = result[0]??"0";
        _faces = faces;
      });

      if (_isRecognized || true) {
        // Redirect to another page with the recognized face ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecognizedPage(userId: _userId, userName: _userName),
          ),
        );
        break;
      } else {
        getFloatingSnackBar(size, 'wajah tidak dikenali', context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size= MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const TextWidget(text: "Scan Wajah Anda", type: 3),
        leading: Container(), // Completely vanishes the leading widget
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_controller),
                CustomPaint(
                  painter: FacePainter(_faces, _isRecognized),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            final inputImage = InputImage.fromFilePath(image.path);
            _processImage(inputImage, size);
          } catch (e) {
            print(e);
          }
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  void getFloatingSnackBar(var size, String string, BuildContext context) {
    SnackBar floatingSnackBar = SnackBar(
      content: Text(
        string,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black,
      margin:  EdgeInsets.only(
          bottom: (size.height / 2) - 40,
          left: size.width / 2 - 100,
          right: size.width / 2 - 100),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(floatingSnackBar);
  }
}

class FacePainter extends CustomPainter {
  final List<Face> faces;
  final bool isRecognized;

  FacePainter(this.faces, this.isRecognized);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = isRecognized ? Colors.green : Colors.red;

    for (final face in faces) {
      Rect newBox= Rect.fromLTWH(
        300- face.boundingBox.left*0.5-130, 
        face.boundingBox.bottom*0.65 -350, 
        face.boundingBox.width*0.4, 
        face.boundingBox.height*0.6
      );
      canvas.drawRect(newBox, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
