import 'dart:async';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'detector_view.dart';
import 'painters/pose_painter.dart';
import 'posedetecter.dart';
import 'package:senior_fitness_app/SFT.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:senior_fitness_app/video3.dart';

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
  final String ngrokBaseUrl = "https://e346-14-44-120-104.ngrok-free.app";

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
  int getModifiedLastChairUpCount(int lastChairUpCount) {
    if (lastChairUpCount > 4 && lastChairUpCount <= 6) {
      return 92;
    } else if (lastChairUpCount > 6 && lastChairUpCount <= 8) {
      return 87;
    } else if (lastChairUpCount > 8 && lastChairUpCount <= 10) {
      return 82;
    } else if (lastChairUpCount > 10 && lastChairUpCount <= 12) {
      return 77;
    } else if (lastChairUpCount > 12 && lastChairUpCount <= 14) {
      return 72;
    } else if (lastChairUpCount > 14 && lastChairUpCount <= 16) {
      return 67;
    } else if (lastChairUpCount > 16 && lastChairUpCount <= 18) {
      return 62;
    } else {
      return 0;
    }
  }

  void _processChairUpCount() {
    if (_chairState == ChairState.standing && _chairUpCount != _lastChairUpCount) {
      setState(() {
        _text_counter = '$_chairUpCount';
        _lastChairUpCount = getModifiedLastChairUpCount(_chairUpCount);
      });
    }
  }
  Future<void> sendPushUpCount(int ChairUpCount) async {
    final String url = '$ngrokBaseUrl/insert'; // 여러분의 Flask 서버 URL로 대체하세요

    final Map<String, dynamic> data = {
      'ChairUpCount': ChairUpCount,
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
    sendPushUpCount(_lastChairUpCount);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('30초간 앉았다 일어서기'),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => VideoScreen()));
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
      bottomNavigationBar: BottomAppBar(
        color: Color(0xffffffff),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                // 메인 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Myfit()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF1F4EF5), // 색상 코드 CEE9E3
                minimumSize: const Size(210.0, 70.0),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('운동페이지로 이동',
                style: TextStyle(color: Colors.white, fontSize: 30.0),
              ),
            )
          ],
        ),
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
