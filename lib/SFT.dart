import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:fl_chart/fl_chart.dart';



class Myfit extends StatelessWidget {
  static String youtubeId = 'AdYRASHRKwE';

  final YoutubePlayerController _con = YoutubePlayerController(
    initialVideoId: youtubeId,
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/roomi.png'),
        title: Text('루미',
          style: TextStyle(
            letterSpacing: 2.0,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 40.0, 0.0, 0.0),
        child: Column(
          children: <Widget>[
            Center(
              child : Text(
                '홍길동님의 점수는?',
                style: TextStyle(
                  letterSpacing: 2.0,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              '90점',
              style: TextStyle(
                letterSpacing: 2.0,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: () {
                // 여기에 측정하기 버튼이 눌렸을 때의 동작 추가
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(210.0, 70.0),
                primary: Colors.lightBlueAccent,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                '측정하기',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              width: 300.0, // 조절하고자 하는 너비
              height: 200.0, // 조절하고자 하는 높이
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: const Color(0xff37434d),
                      width: 1,
                    ),
                  ),
                  minX: 0,
                  maxX: 7,
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 30),
                        FlSpot(1, 40),
                        FlSpot(2, 20),
                        FlSpot(3, 60),
                        FlSpot(4, 50),
                        FlSpot(5, 70),
                        FlSpot(6, 70),
                        FlSpot(7, 90),
                      ],
                      isCurved: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),

            SizedBox(
              width: 300.0, // 조절하고자 하는 너비
              height: 200.0, // 조절하고자 하는 높이
              child : YoutubePlayer(
                controller: _con,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // 여기에 메인으로 이동 버튼이 눌렸을 때의 동작 추가
                },
                style: TextButton.styleFrom(
                  minimumSize: const Size(210.0, 70.0),
                  backgroundColor: Colors.lightBlueAccent,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  '메인으로 이동',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
