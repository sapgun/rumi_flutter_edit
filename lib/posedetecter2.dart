import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'dart:async';
import 'detector_view.dart';
import 'painters/pose_painter.dart';
import 'posedetecter.dart';

enum WalkState {
  stationary, walking
}

class WalkDetectorView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WalkDetectorViewState();
}

class _WalkDetectorViewState extends State<WalkDetectorView> {
  final PoseDetector _poseDetector = PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = false;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  var _cameraLensDirection = CameraLensDirection.back;

  WalkState _walkState = WalkState.stationary;
  int _stepCount = 0;

  @override
  void initState() {
    super.initState();
    startDetection();
  }

  void startDetection() {
    // Start your detection logic if needed
  }

  @override
  void dispose() {
    // Dispose resources and cleanup
    _canProcess = false;
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Walk Detector'),
      ),
      body: Column(
        children: [
          Text(
            'Step Count: $_stepCount',
            style: TextStyle(fontSize: 24),
          ),
          Expanded(
            child: DetectorView(
              customPaint: _customPaint,
              onImage: _processImage,
              initialCameraLensDirection: _cameraLensDirection,
              onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
              title: '',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;

    _isBusy = true;

    final poses = await _poseDetector.processImage(inputImage);
    if (poses.isNotEmpty) {
      final painter = PosePainter(
        poses,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
      final pose = poses.first;

      // Your pose detection logic here

      final leftHip = pose.landmarks[PoseLandmarkType.leftHip]!;
      final leftKnee = pose.landmarks[PoseLandmarkType.leftKnee]!;
      final leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle]!;

      final rightHip = pose.landmarks[PoseLandmarkType.rightHip]!;
      final rightKnee = pose.landmarks[PoseLandmarkType.rightKnee]!;
      final rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle]!;

      final leftLegAngle = calculateAngle([leftHip, leftKnee, leftAnkle]);
      final rightLegAngle = calculateAngle([rightHip, rightKnee, rightAnkle]);

      if ((leftLegAngle > math.pi / 3 || rightLegAngle > math.pi / 3) &&
          _walkState == WalkState.stationary) {
        // Leg angle is large, consider it as walking
        _walkState = WalkState.walking;
        _stepCount++;
      } else if ((leftLegAngle < math.pi / 6 && rightLegAngle < math.pi / 6) &&
          _walkState == WalkState.walking) {
        // Leg angle is small, consider it as stationary
        _walkState = WalkState.stationary;
      }

      setState(() {
        // Update UI if needed
      });
    }

    _isBusy = false;
  }
}
