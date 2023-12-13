import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'detector_view.dart';
import 'painters/pose_painter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// 의자에서 앉았다 일어나기 상태
enum SitStandState {
  sit, stand
}

// 의자에서 앉았다 일어나기 카운트와 상태
int _sitStandCount = 0;
SitStandState _sitStandState = SitStandState.stand;

// 운동 제한 시간 (30초)
final _exerciseTimeLimit = Duration(seconds: 30);
DateTime? _startTime;

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

  Future<http.Response> sendPostRequest(int totalCount, int sitCount) async {
    final uri = Uri.parse('https://a296-175-214-183-100.ngrok.io');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'totalCount': totalCount,
      'sitCount': sitCount,
    });

    final response = await http.post(uri, headers: headers, body: body);

    return response;
  }


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
              onCameraLensDirectionChanged: (value) =>
              _cameraLensDirection = value,
              title: '',
            ),
          ),
        ],
      ),
    );
  }

// 나머지 코드는 동일하게 유지하되, _processImage 함수만 변경합니다.
  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;

    _isBusy = true;

    if (_startTime == null) {
      _startTime = DateTime.now();
    }

    if (DateTime.now().difference(_startTime!) > _exerciseTimeLimit) {
      _canProcess = false;
      _text = 'Time up! Total count: $_sitStandCount';

      // 운동 시간이 끝나면 결과를 서버에 보내는 코드를 추가합니다.
      final response = await sendPostRequest(_sitStandCount, _sitStandState == SitStandState.sit ? 1 : 0);
      if (response.statusCode == 200) {
        print('Data sent successfully');
      } else {
        print('Failed to send data');
      }

      return;
    }

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
      if (angle < math.pi / 2 && _sitStandState == SitStandState.stand) {
        _sitStandState = SitStandState.sit;
      } else if (angle > math.pi * 0.9 && _sitStandState == SitStandState.sit) {
        _sitStandState = SitStandState.stand;
        _sitStandCount++;
      }
    }

    _isBusy = false;
    if (mounted) {
      setState(() {
        _text = '$_sitStandCount';
      });
    }
  }
}