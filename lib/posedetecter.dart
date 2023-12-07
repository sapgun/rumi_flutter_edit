import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'detector_view.dart';
import 'painters/pose_painter.dart';

// 팔굽혀펴기 상태
enum PushUpState {
  up, down
}

// 팔굽혀펴기 카운트와 상태
int _pushUpCount = 0;
PushUpState _pushUpState = PushUpState.up;

// 각도 계산 함수
double calculateAngle(List<PoseLandmark> landmarks) {
  final PoseLandmark a = landmarks[0];
  final PoseLandmark b = landmarks[1];
  final PoseLandmark c = landmarks[2];

  final ba = math.Point(a.x - b.x, a.y - b.y);
  final bc = math.Point(c.x - b.x, c.y - b.y);

  final dotProduct = ba.x * bc.x + ba.y * bc.y;
  final crossProduct = ba.x * bc.y - ba.y * bc.x;

  return math.atan2(crossProduct, dotProduct);
}

class PoseDetectorView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends State<PoseDetectorView> {
  final PoseDetector _poseDetector =
  PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.back;

  @override
  void dispose() async {
    _canProcess = false;
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pose Detector'),
      ),
      body: Column(
        children: <Widget>[
          Text(
            _text ?? '',
            style: TextStyle(fontSize: 24),
          ),
          Expanded(
            child: DetectorView(
              customPaint: _customPaint,
              onImage: _processImage,
              initialCameraLensDirection: _cameraLensDirection,
              onCameraLensDirectionChanged: (value) => _cameraLensDirection = value, title: '',
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
      final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder]!;
      final leftElbow = pose.landmarks[PoseLandmarkType.leftElbow]!;
      final leftWrist = pose.landmarks[PoseLandmarkType.leftWrist]!;

      final angle = calculateAngle([leftShoulder, leftElbow, leftWrist]);
      if (angle < math.pi / 2 && _pushUpState == PushUpState.up) {
        _pushUpState = PushUpState.down;
      } else if (angle > math.pi * 0.9 && _pushUpState == PushUpState.down) {
        _pushUpState = PushUpState.up;
        _pushUpCount++;
      }
    }

    _isBusy = false;
    if (mounted) {
      setState(() {
        _text = '$_pushUpCount';
      });
    }
  }
}