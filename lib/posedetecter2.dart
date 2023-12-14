import 'dart:async';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'detector_view.dart';
import 'painters/pose_painter.dart';

enum WalkingState {
  leftFootUp, rightFootUp
}

int _walkingCount = 0;
WalkingState _walkingState = WalkingState.leftFootUp;

class StepPoseDetectorView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StepPoseDetectorViewState();
}

class _StepPoseDetectorViewState extends State<StepPoseDetectorView> {
  final PoseDetector _poseDetector = PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = false;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text_timer = '3';
  String? _text_counter = '0';
  var _cameraLensDirection = CameraLensDirection.back;

  Timer? _timer;
  int _elapsedTime = 0;

  @override
  void initState() {
    super.initState();
    _text_counter = '0';
    _walkingCount = 0;
    startCountdown();
  }

  int _lastWalkingCount = 0;

  void startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_elapsedTime < 3) {
          _text_timer = '${3 - _elapsedTime}';
        } else if (_elapsedTime == 3) {
          _text_timer = '운동 시작!';
        } else if (_elapsedTime > 3 && _elapsedTime < 123) {
          _canProcess = true;
          _text_timer = (_elapsedTime - 3).toString();
        } else if (_elapsedTime >= 123) {
          _canProcess = false;
          _text_timer = '수고하셨습니다. 운동이 종료되었습니다.';
          timer.cancel();
        }
      });

      _processWalkingCount();
      _elapsedTime++;
    });
  }

  void _processWalkingCount() {
    if (_walkingState == WalkingState.leftFootUp && _walkingCount != _lastWalkingCount) {
      setState(() {
        _text_counter = '$_walkingCount';
        _lastWalkingCount = _walkingCount;
      });
    }
  }

  @override
  void dispose() {
    _canProcess = false;
    _poseDetector.close();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step Pose Detector'),
      ),
      body: Column(
        children: <Widget>[
          Text(
            _text_timer ?? '',
            style: TextStyle(fontSize: 24),
          ),
          Text(
            _text_counter ?? '',
            style: TextStyle(fontSize: 24),
          ),
          if (_elapsedTime >= 123)
            ElevatedButton(
              onPressed: () {
                // 이동할 다음 페이지로 이동하는 코드를 여기에 추가
                // 예시: Navigator.push(context, MaterialPageRoute(builder: (context) => AnotherExercisePage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1F4EF5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: Text(
                '운동 종료, 다른 운동 시작하기',
                style: TextStyle(color: Colors.white),
              ),
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
      final leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle]!;
      final rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle]!;

      final leftFootUp = leftAnkle.y < pose.landmarks[PoseLandmarkType.leftKnee]!.y;
      final rightFootUp = rightAnkle.y < pose.landmarks[PoseLandmarkType.rightKnee]!.y;

      if (leftFootUp && _walkingState == WalkingState.rightFootUp) {
        _walkingState = WalkingState.leftFootUp;
        _walkingCount++;
      } else if (rightFootUp && _walkingState == WalkingState.leftFootUp) {
        _walkingState = WalkingState.rightFootUp;
      }

      setState(() {
        _text_counter = '$_walkingCount';
      });
    }

    _isBusy = false;
  }
}
