import 'package:flutter/material.dart';
import 'package:senior_fitness_app/gender.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BirthDatePage extends StatefulWidget {
  final String name;

  const BirthDatePage({required this.name, Key? key}) : super(key: key);

  @override
  _BirthDatePageState createState() => _BirthDatePageState();
}

class _BirthDatePageState extends State<BirthDatePage> {
  TextEditingController controllerBirthDate = TextEditingController();

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
            "생년월일을 알려주세요",
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
                  padding: const EdgeInsets.fromLTRB(100.0, 50.0, 100.0, 0.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40.0,),
                      TextField(
                        controller: controllerBirthDate,
                        decoration: const InputDecoration(
                          labelText: '생년월일',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        keyboardType: TextInputType.datetime,
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
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('birth', controllerBirthDate.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Gender(
                        name: widget.name,
                        birthDate: controllerBirthDate.text,
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
