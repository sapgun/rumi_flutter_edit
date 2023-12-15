import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'dart:async';
import 'detector_view.dart';
import 'painters/pose_painter.dart';
import 'package:senior_fitness_app/posedetecter1.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum PushUpState {
  up, down
}

int _pushUpCount = 0;
PushUpState _pushUpState = PushUpState.up;

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
  final PoseDetector _poseDetector = PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = false;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text_timer = '3';
  String? _text_counter = '0';
  var _cameraLensDirection = CameraLensDirection.back;
  final String ngrokBaseUrl = "https://e153-175-214-183-100.ngrok-free.app";

  Timer? _timer;
  int _elapsedTime = 0;

  @override
  void initState() {
    super.initState();
    _text_counter = '0'; // 카운트 되는부분이 0으로 초기화가 안되서 초기화 해줌
    _pushUpCount = 0;
    startCountdown();
  }

  int _lastPushUpCount = 0;

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
          _text_timer = '수고하셨습니다.\n다음 운동으로 넘어가주세요';
          timer.cancel();
        }
      });
      _processPushUpCount();
      _elapsedTime++;
    });
  }

  void _processPushUpCount() {
    if (_pushUpState == PushUpState.up && _pushUpCount != _lastPushUpCount) {
      setState(() {
        _text_counter = '$_pushUpCount';
        _lastPushUpCount = _pushUpCount;
      });
    }
  }

  Future<void> sendPushUpCount(int pushUpCount) async {
    final String url = '$ngrokBaseUrl/insert'; // 여러분의 Flask 서버 URL로 대체하세요

    final Map<String, dynamic> data = {
      'pushUpCount': pushUpCount,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // 성공적으로 전송된 경우 여기에서 추가 작업 수행
      print('푸시업 횟수가 성공적으로 전송되었습니다.');
    } else {
      // 전송 중 오류가 발생한 경우 여기에서 처리
      print('푸시업 횟수 전송 중 오류가 발생했습니다. HTTP 상태 코드: ${response.statusCode}');
    }
  }


  @override
  void dispose() {
    _canProcess = false;
    _poseDetector.close();
    _timer?.cancel();
    sendPushUpCount(_lastPushUpCount);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('30초 아령 들기'),
      ),
      body:
      Column(
        children: [
          Text( // 시간 재주는 부분
            _text_timer ?? '',
            style: TextStyle(fontSize: 24),
          ),
          Text( //횟수 카운트 해주는 부분
            _text_counter ?? '',
            style: TextStyle(fontSize: 24),
          ),
          if (_elapsedTime >= 33)
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChairPoseDetectorView()));
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
      final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder]!;
      final leftElbow = pose.landmarks[PoseLandmarkType.leftElbow]!;
      final leftWrist = pose.landmarks[PoseLandmarkType.leftWrist]!;

      final angle = calculateAngle([leftShoulder, leftElbow, leftWrist]);
      if (angle < math.pi / 2 && _pushUpState == PushUpState.up) {
        _pushUpState = PushUpState.down;
        _pushUpCount++;
      } else if (angle > math.pi * 0.8 && _pushUpState == PushUpState.down) {
        _pushUpState = PushUpState.up;
      }

      setState(() {
        _text_counter = '$_pushUpCount';
      });
    }
    _isBusy = false;
  }
}