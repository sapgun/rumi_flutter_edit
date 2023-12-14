import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:senior_fitness_app/video2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:senior_fitness_app/posedetecter.dart';
import 'package:senior_fitness_app/loading.dart';
import 'model/wid.dart';
import 'posedetecter1.dart';


class Myfit extends StatefulWidget {
  const Myfit({Key? key}) : super(key: key);

  @override
  State<Myfit> createState() => _Myfit();
}

class _Myfit extends State<Myfit> {
  String? name;
  String? birth;
  String? gender;
  String? age;
  VideoPlayerController? _controller;
  final String videoPath = 'images/2.mp4';
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(videoPath)
      ..initialize().then((_) {
        setState(() {});
      });
    _loadData();
    fetchData();

    _con = YoutubePlayerController(
      initialVideoId: youtubeId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }
  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/'),
    );
    print('Status code: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> result = jsonDecode(response.body)['data'];
      List<Map<String, dynamic>> data = result.map((item) {
        DateTime date = DateFormat('yyyy-MM-dd').parse(item['workout_date']);
        double count = double.parse(item['dumbbell_count'].toString());
        return {'date': date, 'count': count};
      }).toList();

      // Sort the data by date
      data.sort((a, b) => a['date'].compareTo(b['date']));

      setState(() {
        // Select the last 5 items in the sorted list
        this.data = data.length > 5 ? data.sublist(data.length - 5) : data;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      birth = prefs.getString('birth');
      gender = prefs.getString('gender');
      if (birth != null) {
        DateTime birthDate = DateFormat('yyyy-MM-dd').parse(birth!);
        age = calculateAge(birthDate).toString();
      }
    });
  }

  int calculateAge(DateTime birthDate) {
    final currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    final int month1 = currentDate.month;
    final int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      final int day1 = currentDate.day;
      final int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  static String youtubeId = 'U_Tv31zKYkk';
  YoutubePlayerController? _con;

  // YoutubePlayerController _con = YoutubePlayerController(
  //   initialVideoId: youtubeId,
  //   flags: const YoutubePlayerFlags(
  //     autoPlay: false,
  //     mute: false,
  //   ),
  // );
  bool showOtherData = false;
  int _selectedIndex = 1;
  PageF pagef = PageF();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 80.0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 10.0), // 여백 추가
          child: Image.asset('images/rumi.png'),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0), // 텍스트 위쪽 여백 추가
          child: Text(
            '루미',
            style: TextStyle(
              letterSpacing: 2.0,
              fontSize: 35.0,
              fontWeight: FontWeight.bold,
              height: 1.2, // 텍스트의 높이 조절
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: Text(
                '$name 님의 결과입니다.',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.175, // 70 대신에 사용
                  height: 50,
                  color: Color(0xFF1F4EF5), // 'CEE9E3' 색상
                  child: Center(
                    child: Text(
                      '나이',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white, // 텍스트 색상을 흰색으로 변경
                      ),
        ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.175, // 70 대신에 사용
                  height: 50,
                  color: Colors.white,
                  child: Center(
                    child: Text('$age', style: TextStyle(fontSize: 20)),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25, // 100 대신에 사용
                  height: 50,
                  color: Color(0xFF1F4EF5), // 'CEE9E3' 색상
                  child: Center(
                    child: Text(
                      '신체나이',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white, // 텍스트 색상을 흰색으로 변경
                      ),
                    ),
                  ),
                ),
                Container(
                  width:
                      MediaQuery.of(context).size.width * 0.275, // 110 대신에 사용
                  height: 50,
                  color: Colors.white,
                  child: Center(
                    child: Text('80', style: TextStyle(fontSize: 20)),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.1,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PoseDetectorView()),
                  );
                },
                child: Text(
                  '임시버튼',
                  style: TextStyle(color: Colors.white, fontSize: 28.0),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF1F4EF5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: () {
                if (_controller!.value.isInitialized) {
                  setState(() {
                    _controller!.value.isPlaying
                        ? _controller!.pause()
                        : _controller!.play();
                  });
                }
                // 여기에 측정하기 버튼이 눌렸을 때의 동작 추가
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VideoScreen()),
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
              child: Text(
                '측정하기',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8, // 800 대신에 사용
              height: MediaQuery.of(context).size.height * 0.6, // 700 대신에 사용
              decoration: BoxDecoration(
                color: Color(0xFF83B4F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 30.0,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (_selectedIndex == 1) {
                                _selectedIndex = 6;
                              } else {
                                _selectedIndex = _selectedIndex - 1;
                                youtubeId = pagef.getyoutubeId(_selectedIndex)!;
                                print(youtubeId);
                                _con!.load(youtubeId);
                                Future.delayed(Duration(seconds: 1), () {
                                  _con!.pause(); // 재생 멈추기
                                });
                              }
                            });
                          },
                          child: Icon(Icons.arrow_back),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5)), // 패딩 조정
                            minimumSize:
                                MaterialStateProperty.all(Size(30, 30)),
                            backgroundColor: MaterialStateProperty.all(
                                Colors.white), // 최소 크기 설정
                          ),
                        ),
                        Flexible(
                          child:
                              Container(child: pagef.getText1(_selectedIndex)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (_selectedIndex == 6) {
                                _selectedIndex = 1;
                              } else {
                                _selectedIndex = _selectedIndex + 1;
                                youtubeId = pagef.getyoutubeId(_selectedIndex)!;
                                print(youtubeId);
                                _con!.load(youtubeId);
                                Future.delayed(Duration(seconds: 1), () {
                                  _con!.pause(); // 재생 멈추기
                                });
                              }
                            });
                          },
                          child: Icon(Icons.arrow_forward),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5)),
                            minimumSize:
                                MaterialStateProperty.all(Size(30, 30)),
                            backgroundColor: MaterialStateProperty.all(
                                Colors.white), // 최소 크기 설정
                          ),
                        ),
                        SizedBox(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: data.isEmpty
                          ? CircularProgressIndicator()
                          : LineChart(
                        LineChartData(
                          backgroundColor: Color(0xFFFFFDFD),
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          minX: data.first['date'].month.toDouble(),
                          maxX: data.last['date'].month.toDouble(),
                          minY: 8,
                          maxY: 15,
                          lineBarsData: [
                            LineChartBarData(
                              spots: pagef.getData(data, _selectedIndex),
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Column(
                      children: [
                        Text(
                          '오늘의 추천 운동',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        YoutubePlayer(
                          controller: _con!,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // ),

      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Loading()),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF1F4EF5),
                  minimumSize: const Size(210.0, 70.0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  '처음으로 이동',
                  style: TextStyle(color: Colors.white, fontSize: 30.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
