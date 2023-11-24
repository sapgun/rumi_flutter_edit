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
  String? selectedGender;

  void _handleRegistration() {
    // SharedPreferences에 데이터 저장
    _saveDataToSharedPreferences(selectedGender!);
    // 초기 화면으로 이동
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
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
      body: Column(
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
          Expanded(
            child: Form(
              child: Theme(
                data: ThemeData(
                  primaryColor: Colors.black,
                  inputDecorationTheme: const InputDecorationTheme(
                    labelStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                ),
                child: Container(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildGenderCard('남성', Icons.male),
                          buildGenderCard('여성', Icons.female),
                        ],
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // 성별 선택 처리 및 회원가입 처리
                  _handleRegistration();
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
                  '입력완료',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGenderCard(String gender, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.35,
        height: MediaQuery.of(context).size.width * 0.35,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: selectedGender == gender
              ? Colors.lightBlueAccent
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40.0,
                color: selectedGender == gender ? Colors.white : Colors.black,
              ),
              SizedBox(height: 10),
              Text(
                gender,
                style: TextStyle(
                  fontSize: 18.0,
                  color: selectedGender == gender ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
