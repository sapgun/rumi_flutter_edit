import 'package:flutter/material.dart';
import 'package:senior_fitness_app/SFT.dart';
import 'package:senior_fitness_app/chatbot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:intl/intl.dart';
import 'model/model.dart';

const apiKey = '34d28a43a906e26fedcd5528c23e32df';

class Dashboard extends StatefulWidget {
  Dashboard({this.parseWeatherData, this.parseAirPollution});

  final dynamic parseWeatherData;
  final dynamic parseAirPollution;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Model model = Model();
  String? name;
  String? birth;
  String? gender;
  String? cityCode;
  String? cityName;
  int? temp;
  Widget? icon;
  String? des;
  Widget? airIcon;
  Widget? airState;
  double? dust1;
  double? dust2;
  var date = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
    updateData(widget.parseWeatherData, widget.parseAirPollution);
  }

  void updateData(dynamic weatherData, dynamic airData) {
    double temp2 = weatherData['main']['temp'].toDouble();
    int condition = weatherData['weather'][0]['id'];
    int index = airData['list'][0]['main']['aqi'];
    des = model.weatherDescKo[weatherData['weather'][0]['id']];
    temp = temp2.round();
    cityName = model.getKrCityName(weatherData['name']);
    icon = model.getWeatherIcon(condition);
    airIcon = model.getAirIcon(index);
    airState = model.getAirCondition(index);
    dust1 = airData['list'][0]['components']['pm10'];
    dust2 = airData['list'][0]['components']['pm2_5'];
  }

  String getSystemTime() {
    var now = DateTime.now();
    return DateFormat("a h:mm", 'ko_KR').format(now);
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      birth = prefs.getString('birth');
      gender = prefs.getString('gender');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 80.0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 10.0),
          child: Image.asset('images/rumi.png'),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            '루미',
            style: TextStyle(
              letterSpacing: 2.0,
              fontSize: 35.0,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Column(
                  children: [
                    Text(
                      '$name 님',
                      style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$cityName',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('yyyy년 MM월 dd일 EEEE ', 'ko_KR').format(date),
                          style: GoogleFonts.lato(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                        TimerBuilder.periodic(
                          (Duration(minutes: 1)),
                          builder: (context) {
                            print('${getSystemTime()}');
                            return Text(
                              '${getSystemTime()}',
                              style: GoogleFonts.lato(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '$temp\u2103',
                      style: TextStyle(
                        fontSize: 85.0,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        icon!,
                        Text(
                          '$des',
                          style: GoogleFonts.lato(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Divider(
                  height: 15.0,
                  thickness: 2.0,
                  color: Colors.black12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 10.0,),
                    Column(
                      children: [
                        Text(
                          '대기질지수',
                          style: GoogleFonts.lato(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        airIcon!,
                        SizedBox(
                          height: 10.0,
                        ),
                        airState!,
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '미세먼지',
                          style: GoogleFonts.lato(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          '$dust1',
                          style: GoogleFonts.lato(
                            fontSize: 24.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          '㎍/m³',
                          style: GoogleFonts.lato(
                            fontSize: 14.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '초미세먼지',
                          style: GoogleFonts.lato(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          '$dust2',
                          style: GoogleFonts.lato(
                            fontSize: 24.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          '㎍/m³',
                          style: GoogleFonts.lato(
                            fontSize: 14.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10.0,),
                  ],
                )
              ],
            ),
            Column(
              children: [
                Divider(
                  height: 15.0,
                  thickness: 2.0,
                  color: Colors.black12,
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.width * 0.4,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Myfit()),
                      );
                    },
                    child: Text(
                      '운동하기',
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
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.width * 0.4,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Chatbot()),
                      );
                    },
                    child: Text(
                      '말동무',
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
