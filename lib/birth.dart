import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:senior_fitness_app/gender.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class BirthDatePage extends StatefulWidget {
  final String name;

  const BirthDatePage({required this.name, Key? key}) : super(key: key);

  @override
  _BirthDatePageState createState() => _BirthDatePageState();
}

class _BirthDatePageState extends State<BirthDatePage> {
  DateTime _birthDate = DateTime(1970, 1, 1);
  DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50.0,
            ),
            Text(
              "생년월일을 알려주세요",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.085 > 40.0
                    ? 40.0
                    : MediaQuery.of(context).size.width * 0.085,
                fontWeight: FontWeight.bold,
              ),
            ),
            Form(
              child: Theme(
                data: ThemeData(
                  primaryColor: Colors.black,
                  inputDecorationTheme: const InputDecorationTheme(
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 10.0),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(100.0, 50.0, 100.0, 0.0),
                  child: Column(
                    children: [
                      SizedBox(height: 40.0,),
                      BirthDatePicker(
                        onDateTimeChanged: (newDateTime) {
                          setState(() {
                            _birthDate = newDateTime;
                          });
                        },
                        initDateStr: _dateFormat.format(_birthDate),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Text(
              '이름: ${widget.name}',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 10.0,),
            // SizedBox(height: 0.0,),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('birth', _dateFormat.format(_birthDate));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Gender(
                        name: widget.name,
                        birthDate: _dateFormat.format(_birthDate),
                      ),
                    ),
                  );
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
}

class BirthDatePicker extends StatelessWidget {
  final void Function(DateTime) onDateTimeChanged;
  final String initDateStr;

  BirthDatePicker({
    required this.onDateTimeChanged,
    this.initDateStr = '2000-01-01',
  });

  @override
  Widget build(BuildContext context) {
    final initDate = DateFormat('yyyy-MM-dd').parse(initDateStr ?? '2000-01-01');

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return CupertinoTheme(
      data: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          dateTimePickerTextStyle: TextStyle(
            fontSize: (deviceHeight * 0.02 + deviceWidth * 0.02) / 2,
            // fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      child: SizedBox(
        height: deviceHeight * 0.3,
        width: deviceWidth * 1,
        child: CupertinoDatePicker(
          minimumYear: 1900,
          maximumYear: DateTime.now().year,
          initialDateTime: initDate,
          maximumDate: DateTime.now(),
          onDateTimeChanged: onDateTimeChanged,
          mode: CupertinoDatePickerMode.date,
        ),
      ),
    );
  }
}