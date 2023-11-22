import 'package:flutter/material.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({Key? key}) : super(key: key);

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).backgroundColor;
    Color buttonColor = Colors.lightBlueAccent;

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('images/rumi.png'),
        title: Text(
          '루미',
          style: TextStyle(
            letterSpacing: 2.0,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          // 첫 번째 버튼
          Positioned(
            top: 100,
            left: 40,
            child: ElevatedButton(
              onPressed: () {
                // 버튼이 눌렸을 때 수행할 동작 추가
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20),
                shape: CircleBorder(),
                primary: buttonColor, // 첫 번째 버튼 배경색을 연한 하늘색으로 설정
              ),
              child: Image.asset('images/rumi.png', width: 130, height: 130),
            ),
          ),
          // 두 번째 버튼
          Positioned(
            top: 100,
            right: 40,
            child: ElevatedButton(
              onPressed: () {
                // 버튼이 눌렸을 때 수행할 동작 추가
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20),
                shape: CircleBorder(),
                primary: buttonColor, // 두 번째 버튼 배경색을 연한 하늘색으로 설정
              ),
              child: Image.asset('images/rumi.png', width: 130, height: 130),
            ),
          ),
          // (처음으로) 버튼
          Positioned(
            bottom: 50,
            left: MediaQuery.of(context).size.width / 2 - 120, // 가운데 정렬을 위해 화면 너비를 이용
            child: ElevatedButton(
              onPressed: () {
                // 처음으로 버튼이 눌렸을 때 메인 페이지로 이동
                Navigator.pop(context); // 현재 페이지를 스택에서 제거하여 이전 페이지로 이동
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(240, 80), // 버튼 크기 조절
                primary: buttonColor, // (처음으로) 버튼 배경색을 연한 하늘색으로 설정
              ),
              child: Text(
                '처음으로',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
