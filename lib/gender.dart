import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:senior_fitness_app/main.dart';

class Gender extends StatefulWidget {
  final String name;
  final String birthDate;

  const Gender({required this.name, required this.birthDate, Key? key})
      : super(key: key);

  @override
  _GenderState createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  bool isMale = false;
  bool isFemale = false;

  void _handleRegistration() {
    // 선택된 성별을 문자열로 변환하여 저장
    String selectedGender = '';
    if (isMale) {
      selectedGender = '남성';
    } else if (isFemale) {
      selectedGender = '여성';
    }

    // SharedPreferences에 데이터 저장
    _saveDataToSharedPreferences(selectedGender);

    // 예를 들어, 회원가입 로직을 수행하는 함수를 호출
    // _performRegistration(selectedGender);

    // 초기 화면으로 이동
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }
  void _saveDataToSharedPreferences(String selectedGender) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('gender', selectedGender);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50.0,
            ),
            Text(
              "성별을 선택해주세요",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.085,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(100.0, 50.0, 100.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CheckboxListTile(
                    title: Text('남성'),
                    value: isMale,
                    onChanged: (value) {
                      setState(() {
                        isMale = value!;
                        if (isMale) {
                          // 남성이 선택되었을 때 추가 작업 수행
                          // 여기서 다른 성별 선택을 해제할 필요는 없습니다.
                          isFemale = false;
                        }
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('여성'),
                    value: isFemale,
                    onChanged: (value) {
                      setState(() {
                        isFemale = value!;
                        if (isFemale) {
                          // 여성이 선택되었을 때 추가 작업 수행
                          // 여기서 다른 성별 선택을 해제할 필요는 없습니다.
                          isMale = false;
                        }
                      });
                    },
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Text(
                    '이름: ${widget.name}',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    '생년월일: ${widget.birthDate}',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // 성별 선택 처리 및 회원가입 처리
                      _handleRegistration();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100.0, 50.0),
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 35.0,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
