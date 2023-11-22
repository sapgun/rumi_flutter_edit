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
      body: SingleChildScrollView(
        child: Column(
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
            Form(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      const SizedBox(
                        height: 40.0,
                      ),
                      ElevatedButton(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
