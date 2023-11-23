import 'package:flutter/material.dart';
import 'package:senior_fitness_app/SFT.dart';
import 'package:senior_fitness_app/chatbot.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.4,
              child: TextButton(
                onPressed: () {
                  // 첫 번째 버튼을 누르면 다음 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Myfit()),
                  );
                },
                child: Center(
                  child: Text(
                    '운동하기',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0
                    ),
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
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
                  // 두 번째 버튼을 누르면 다음 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Chatbot()),
                  );
                },
                child: Center(
                  child: Text(
                    '말동무',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0
                    ),
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
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
