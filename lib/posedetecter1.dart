import 'dart:async';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'detector_view.dart';
import 'painters/pose_painter.dart';
import 'posedetecter.dart';
import 'package:senior_fitness_app/posedetecter2.dart';


enum ChairState {
  sitting, standing
}

int _chairUpCount = 0;
ChairState _chairState = ChairState.standing;

class ChairPoseDetectorView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChairPoseDetectorViewState();
}

class _ChairPoseDetectorViewState extends State<ChairPoseDetectorView> {
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
    _text_counter = '0'; // 카운트 되는부분이 0으로 초기화가 안되서 초기화 해줌
    _chairUpCount = 0;
    startCountdown();
  }

  int _lastChairUpCount = 0; // 이전 의자 일어남 카운트를 저장할 변수 추가

  void startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_elapsedTime < 3) {
          _text_timer = '${3 - _elapsedTime}';
        } else if (_elapsedTime == 3) {
          _text_timer = '운동 시작!';
        } else if (_elapsedTime > 3 && _elapsedTime < 33) {
          _canProcess = true;
          _text_timer = (_elapsedTime - 3).toString();
        } else if (_elapsedTime >= 33) {
          _canProcess = false;
          _text_timer = '수고하셨습니다. 다음 운동으로 넘어가주세요';
          timer.cancel();
        }
      });

      _processChairUpCount(); // 갯수 카운트를 처리하는 함수 호출
      _elapsedTime++;
    });
  }

  void _processChairUpCount() {
    if (_chairState == ChairState.standing && _chairUpCount != _lastChairUpCount) {
      setState(() {
        _text_counter = '$_chairUpCount';
        _lastChairUpCount = _chairUpCount;
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
        title: Text('Chair Pose Detector'),
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
          if (_elapsedTime >= 10)
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => WalkDetectorView()));
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
      final leftHip = pose.landmarks[PoseLandmarkType.leftHip]!;
      final leftKnee = pose.landmarks[PoseLandmarkType.leftKnee]!;
      final leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle]!;

      final angle = calculateAngle([leftHip, leftKnee, leftAnkle]);
      if (angle < math.pi * 0.55 && _chairState == ChairState.sitting) {
        _chairState = ChairState.standing;
      } else if (angle > math.pi * 0.8 && _chairState == ChairState.standing) {
        _chairState = ChairState.sitting;
        _chairUpCount++;
      }

      setState(() {
        _text_counter = '$_chairUpCount';
      });
    }

    _isBusy = false;
  }
}
