import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MyApp1 extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp1> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
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

  @override
  Widget build(BuildContext context) {
    final int maxDataToShow = 5;

    return Scaffold(
      body: Center(
        child: data.isEmpty
            ? CircularProgressIndicator()
            : LineChart(
          LineChartData(
            minX: data.first['date'].month.toDouble(),
            maxX: data.last['date'].month.toDouble(),
            minY: 8,
            maxY: 15,
            lineBarsData: [
              LineChartBarData(
                spots: data
                    .take(maxDataToShow)
                    .map((item) => FlSpot(
                  item['date'].month.toDouble(),
                  item['count'],
                ))
                    .toList(),
                isCurved: true,
                barWidth: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
