import 'package:flutter/material.dart';
import 'package:senior_fitness_app/dashboard.dart';
import 'package:senior_fitness_app/rumi_chat.dart';

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 기존 버튼들
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildImageWithButton(), // 두 번째 버튼은 이미지가 들어간 버튼
              SizedBox(width: 40),
              buildButton(), // 세 번째 버튼은 + 형태의 아이콘 버튼
            ],
          ),
          // 새로 추가된 버튼들
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20.0, // 수평 간격 조절
            runSpacing: 20.0, // 수직 간격 조절
            children: buttons,
          ),
        ],
      ),
      // (처음으로) 버튼
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     // 처음으로 버튼이 눌렸을 때 메인 페이지로 이동
      //     Navigator.pop(context);
      //   },
      //   label: Padding(
      //     padding: const EdgeInsets.symmetric(vertical: 12.0), // 상하 여백 추가
      //     child: Text(
      //       '처음으로',
      //       style: TextStyle(fontSize: 18, color: Colors.white),
      //     ),
      //   ),
      //   icon: Icon(Icons.arrow_back),
      //   backgroundColor: Colors.lightBlueAccent,
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // 변경된 부분: BottomAppBar 추가
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dashboard()),
                  );
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
                  style: TextStyle(color: Colors.white, fontSize: 30.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 새로운 버튼을 추가하는 함수
  void addNewButton() {
    setState(() {
      buttons.add(buildButton());
    });
  }

  // 이미지가 들어간 버튼을 만드는 함수 (두 번째 버튼용)
  Widget buildImageWithButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => rumi_chat()),
        );
        // 여기에 메인으로 이동 버튼이 눌렸을 때의 동작 추가
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20),
        shape: CircleBorder(),
        primary: buttonColor,
      ),
      child: Image.asset('images/rumi.png', width: buttonWidth, height: buttonWidth),
    );
  }

  // 버튼을 만드는 함수
  Widget buildButton() {
    // 세 번째 이후의 버튼은 + 형태의 아이콘 버튼
    return ElevatedButton(
      onPressed: () {
        // 버튼이 눌렸을 때 수행할 동작 추가
        addNewButton();
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20),
        shape: CircleBorder(),
        primary: buttonColor,
      ),
      child: Icon(Icons.add, size: buttonWidth), // + 형태의 아이콘
    );
  }
}
