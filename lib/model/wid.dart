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
  double calculateMinY(int index) {
    switch (index) {
      case 1:
        return 5;
      case 2:
        return 0;
      case 3:
        return 40;
      case 4:
        return -17;
      case 5:
        return -27;
      case 6:
        return 4;
      default:
        return 0; // Default value, modify as needed
    }
  }

  double calculateMaxY(int index) {
    switch (index) {
      case 1:
        return 25;
      case 2:
        return 20;
      case 3:
        return 120;
      case 4:
        return 15;
      case 5:
        return 4;
      case 6:
        return 10;
      default:
        return 100; // Default value, modify as needed
    }
  }


  List<FlSpot> getData(List<Map<String, dynamic>> data, int index) {
    if (index >= 1 && index <= 6) {
      return data
          .take(maxDataToShow)
          .map((item) {
        double value;
        switch (index) {
          case 1:
            value = item['dumbbellCount'] as double? ?? 0.0;
            break;
          case 2:
            value = item['sitCount'] as double? ?? 0.0;
            break;
          case 3:
            value = item['stepCount'] as double? ?? 0.0;
            break;
          case 4:
            value = item['handCount'] as double? ?? 0.0;
            break;
          case 5:
            value = item['backCount'] as double? ?? 0.0;
            break;
          case 6:
            value = item['obstacleCount'] as double? ?? 0.0;
            break;
          default:
            value = 0.0;
        }
        return FlSpot(item['date'].month.toDouble(), value);
      })
          .toList();
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
