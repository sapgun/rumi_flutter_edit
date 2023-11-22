import 'package:flutter/material.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({Key? key}) : super(key: key);

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  Color backgroundColor = Colors.white;
  Color buttonColor = Colors.lightBlueAccent;

  double buttonWidth = 100;

  List<Widget> buttons = [];

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 기존 버튼들
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButton(),
              SizedBox(width: 20),
              buildButton(),
            ],
          ),
          // 새로 추가된 버튼들
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20.0,
            runSpacing: 20.0,
            children: buttons,
          ),
        ],
      ),
      // (처음으로) 버튼
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // 처음으로 버튼이 눌렸을 때 메인 페이지로 이동
          Navigator.pop(context);
        },
        label: Text(
          '처음으로',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        icon: Icon(Icons.arrow_back),
        backgroundColor: Colors.lightBlueAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // 새로운 버튼을 추가하는 함수
  void addNewButton() {
    setState(() {
      buttons.add(buildButton());
    });
  }

  // 버튼을 만드는 함수
  Widget buildButton() {
    return ElevatedButton(
      onPressed: () {
        // 두 번째 버튼이 눌렸을 때 새로운 버튼 추가
        addNewButton();
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20),
        shape: CircleBorder(),
        primary: buttonColor,
      ),
      child: Image.asset('images/rumi.png', width: buttonWidth, height: buttonWidth),
    );
  }
}
