import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class PageF {
  static const int maxDataToShow = 5;
  List<Map<String, dynamic>> data = [];

  Widget? getText1(int index) {
    if (index == 1) {
      return Text(
        '아령 들기',
        style: TextStyle(
          letterSpacing: 2.0,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    if (index == 2) {
      return Text(
        '앉았다 일어서기',
        style: TextStyle(
          letterSpacing: 2.0,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    if (index == 3) {
      return Text(
        '스텝 테스트',
        style: TextStyle(
          letterSpacing: 2.0,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    if (index == 4) {
      return Text(
        '의자에 앉아 손 뻗기',
        style: TextStyle(
          letterSpacing: 2.0,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    if (index == 5) {
      return Text(
        '등 뒤로 손 닿기',
        style: TextStyle(
          letterSpacing: 2.0,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    if (index == 6) {
      return Text(
        '의자에서 일어나 장애물 돌기',
        style: TextStyle(
          letterSpacing: 2.0,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  List<FlSpot> getData(List<Map<String, dynamic>> data, int index) {
    if (index == 1) {
      return data
          .take(maxDataToShow)
          .map((item) =>
          FlSpot(
            item['date'].month.toDouble(),
            item['count'],
          ))
          .toList();
    }
    else if (index == 2) {
      return [
        FlSpot(0, 80),
        FlSpot(1, 20),
        FlSpot(2, 30),
        FlSpot(3, 40),
        FlSpot(4, 10),
        FlSpot(5, 90),
        FlSpot(6, 80),
        FlSpot(7, 70),
      ];
    }
    else if (index == 3) {
      return [
        FlSpot(0, 30),
        FlSpot(1, 10),
        FlSpot(2, 50),
        FlSpot(3, 40),
        FlSpot(4, 60),
        FlSpot(5, 80),
        FlSpot(6, 90),
        FlSpot(7, 20),
      ];
    }
    else if (index == 4) {
      return [
        FlSpot(0, 20),
        FlSpot(1, 10),
        FlSpot(2, 50),
        FlSpot(3, 70),
        FlSpot(4, 20),
        FlSpot(5, 10),
        FlSpot(6, 40),
        FlSpot(7, 60),
      ];
    }
    else if (index == 5) {
      return [
        FlSpot(0, 80),
        FlSpot(1, 20),
        FlSpot(2, 10),
        FlSpot(3, 20),
        FlSpot(4, 40),
        FlSpot(5, 10),
        FlSpot(6, 20),
        FlSpot(7, 10),
      ];
    }
    else if (index == 6) {
      return [
        FlSpot(0, 80),
        FlSpot(1, 70),
        FlSpot(2, 80),
        FlSpot(3, 90),
        FlSpot(4, 70),
        FlSpot(5, 80),
        FlSpot(6, 60),
        FlSpot(7, 90),
      ];
    }
    else {
    // 그 외의 경우에 대한 기본값
    return [];
    }
  }

  String? getyoutubeId(int index) {
    if (index == 1) {
      return "U_Tv31zKYkk";
    }
    if (index == 2) {
      return "wuUt7Cwx08c";
    }
    if (index == 3) {
      return "UmCv5C5Yp4U";
    }
    if (index == 4) {
      return "U_Tv31zKYkk";
    }
    if (index == 5) {
      return "U_Tv31zKYkk";
    }
    if (index == 6) {
      return "U_Tv31zKYkk";
    }
  }

  Widget? getyoutube(String youtubeId, int index) {
    YoutubePlayerController con = YoutubePlayerController(
      initialVideoId: youtubeId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    return YoutubePlayer(
      controller: con,
    );
  }
}
