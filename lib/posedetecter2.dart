import 'dart:math' as math;
import 'dart:async';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:http/http.dart' as http;

import 'detector_view.dart';
import 'painters/pose_painter.dart';
import 'posedetecter.dart';

enum WalkState {
  leftUp,
  rightUp,
  leftdown,
  rightdown,
  noneUp,
}

int _stepCount = 0;
WalkState _walkState = WalkState.noneUp;

class WalkDetectorView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WalkDetectorViewState();
}

class _WalkDetectorViewState extends State<WalkDetectorView> {
  final PoseDetector _poseDetector = PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = false;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text_timer = '3';
  String? _text_counter = '0';
  String? lz = '';
  String? rz = '';
  var _cameraLensDirection = CameraLensDirection.back;

  Timer? _timer;
  int _elapsedTime = 0;

  @override
  void initState() {
    super.initState();
    _text_counter = '0';
    _stepCount = 0;
    startCountingSteps();
  }
  int _lastStepCount = 0;

  void startCountingSteps() {
    Timer.periodic(Duration(seconds: 1), (timer) {
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
          _text_timer = '수고하셨습니다.\n다음 운동으로 넘어가주세요';
          timer.cancel();
        }
      });
      _processStepCount();
      _elapsedTime++;
    });
  }

  void _processStepCount() {
    if (_walkState == WalkState.noneUp && _stepCount != _lastStepCount) {
      setState(() {
        _text_counter = '$_stepCount';
        _lastStepCount = _stepCount;
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
        title: Text('120초 제자리걷기'),
      ),
      body: Column(
        children: [
          Text( // 시간 재주는 부분
            _text_timer ?? '',
            style: TextStyle(fontSize: 24),
          ),
          Text( //횟수 카운트 해주는 부분
            _text_counter ?? '',
            style: TextStyle(fontSize: 24),
          ),
          Text(
            lz!,
            style: TextStyle(fontSize: 18),
          ),
          Text(
            rz!,
            style: TextStyle(fontSize: 18),
          ),
          if (_elapsedTime >= 123)
            ElevatedButton(
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ChairPoseDetectorView()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1F4EF5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: Text(
                '다음 운동으로 넘어가기',
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
      final leftKnee = pose.landmarks[PoseLandmarkType.leftKnee]!;
      final rightKnee = pose.landmarks[PoseLandmarkType.rightKnee]!;

      // 무릎의 z-값 사용
      final leftKneeZ = leftKnee.z;
      final rightKneeZ = rightKnee.z;

      // 귀하의 요구에 따라 적절한 임계값을 설정하십시오
      final kneeThreshold = -200;

      if (leftKneeZ < kneeThreshold) {
        if (_walkState != WalkState.leftUp) {
          _walkState = WalkState.leftUp;
          _stepCount++;
        }
      } else if (rightKneeZ < kneeThreshold) {
        if (_walkState != WalkState.rightUp) {
          _walkState = WalkState.rightUp;
          _stepCount++;
        }
      } else if (leftKneeZ > kneeThreshold && rightKneeZ > kneeThreshold) {
        if (_walkState == WalkState.leftUp || _walkState == WalkState.rightUp) {
          _walkState = WalkState.noneUp;
        }
      }

      setState(() {
        _text_counter = '$_stepCount';
        lz = '$leftKneeZ';
        rz = '$rightKneeZ';
      });
    }

    _isBusy = false;
  }

}

