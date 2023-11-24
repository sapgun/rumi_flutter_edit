import 'package:flutter/material.dart';
import 'package:senior_fitness_app/name.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:senior_fitness_app/dashboard.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rumi',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? name;
  String? gender;

  @override
  void initState() {
    super.initState();
    loadValues();
  }

  Future<void> loadValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool initialDataExists = prefs.getBool('initialDataExists') ?? false;

    if (initialDataExists) {
      name = prefs.getString('name');
      gender = prefs.getString('gender');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 60.0,
                child: Image.asset(
                  'images/rumi.png',
                  width: 120.0,
                  height: 120.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                '루미',
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              if (name != null && gender != null)
                Column(
                  children: [
                    Text(
                      '$name ${gender == '남성' ? '할아버지' : '할머니'}',
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2.0,
                        fontSize: 25,
                      ),
                    ),
                    const Text(
                      '어서오세요',
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2.0,
                        fontSize: 25,
                      ),
                    ),
                    const Text(
                      '보고 싶었어요!',
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2.0,
                        fontSize: 25,
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    const Text(
                      '할머니, 할아버지',
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2.0,
                        fontSize: 25,
                      ),
                    ),
                    const Text(
                      '처음 뵙겠습니다!',
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2.0,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 200),
              TextButton(
                onPressed: () async {
                  SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  bool initialDataExists =
                      prefs.getBool('initialDataExists') ?? false;

                  if (initialDataExists) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Dashboard()),
                    );
                  } else {
                    prefs.setBool('initialDataExists', true);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Name()),
                    );
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  minimumSize: const Size(210.0, 70.0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  '시작하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
