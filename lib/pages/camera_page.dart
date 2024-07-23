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

  void _processImage(InputImage inputImage) async {
    final faceDetector = GoogleMlKit.vision.faceDetector();
    final faces = await faceDetector.processImage(inputImage);

    for (final face in faces) {
      final isRecognized = await _faceRecognition.recognizeFace(face);
      setState(() {
        _isRecognized = isRecognized;
        _faces = faces;
      });
      if (isRecognized) {
        // Redirect to another page
        Navigator.push(context, MaterialPageRoute(builder: (context) => RecognizedPage()));
        return;
      }
    }
    // If no face is recognized, show the snackbar
    if (!_isRecognized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('wajah tidak dikenali'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const TextWidget(text: "Scan Your Face", type: 3),
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
            _processImage(inputImage);
          } catch (e) {
            print(e);
          }
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}

class RecognizedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recognized')),
      body: const Center(child: Text('Face recognized successfully!')),
    );
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
