// 필요한 패키지를 import 합니다
import 'package:flutter/material.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({Key? key}) : super(key: key);

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Theme.of(context).backgroundColor,
              child: Image.asset(
                'assets/rumi.png', // 여러분이 사용하는 PNG 파일의 경로로 업데이트하세요
                fit: BoxFit.fitWidth, // 또는 BoxFit.fitHeight로 설정
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              '루미',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}