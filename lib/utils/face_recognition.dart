import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:math';

class FaceRecognition {
  List<Map<String, dynamic>> _dummyFaceData = [];

  FaceRecognition() {
    _loadDummyFaceData();
  }

  Future<void> _loadDummyFaceData() async {
    final String response = await rootBundle.loadString('assets/face_data.json');
    final List<dynamic> data = json.decode(response);
    _dummyFaceData = data.cast<Map<String, dynamic>>();
  }

  List<double> _extractFaceFeatures(Face face) {
    // Dummy feature extraction logic
    // In a real scenario, you would extract actual features from the detected face
    return [face.boundingBox.left, face.boundingBox.top, face.boundingBox.width, face.boundingBox.height];
  }

  bool _compareFeatures(List<double> faceFeatures, List<double> modelFeatures) {
    // Simple Euclidean distance comparison
    double distance = 0.0;
    for (int i = 0; i < faceFeatures.length; i++) {
      distance += pow(faceFeatures[i] - modelFeatures[i], 2);
    }
    distance = sqrt(distance);

    const threshold = 0.6; // Adjust this value based on your requirements
    return distance < threshold;
  }

  Future<bool> recognizeFace(Face face) async {
    final faceFeatures = _extractFaceFeatures(face);

    for (final model in _dummyFaceData) {
      final modelFeatures = List<double>.from(model['features']);
      if (_compareFeatures(faceFeatures, modelFeatures)) {
        return true;
      }
    }
    return false;
  }
}
