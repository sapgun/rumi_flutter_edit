import 'package:flutter/material.dart';
import 'package:senior_fitness_app/name.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:senior_fitness_app/dashboard.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rumi',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircleAvatar(
                backgroundImage: AssetImage('images/rumi.png'),
                backgroundColor: Colors.white,
                radius: 60.0,
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
              const Text(
                '할머니, 할아버지',
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                  fontSize: 25,
                ),
              ),
              const Text(
                '보고싶었어요',
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                  fontSize: 25,
                ),
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
                  '끝내기',
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

