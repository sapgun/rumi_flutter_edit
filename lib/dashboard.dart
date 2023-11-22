import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('images/rumi.png'),
        title: Text('루미',
          style: TextStyle(
            letterSpacing: 2.0,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // 첫 번째 버튼을 누르면 다음 페이지로 이동
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => FirstPage()),
              // );
            },
            child: Text('첫 번째 페이지로 이동'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // 두 번째 버튼을 누르면 다음 페이지로 이동
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => SecondPage()),
              // );
            },
            child: Text('두 번째 페이지로 이동'),
          ),
        ],
      ),
    );
  }
}