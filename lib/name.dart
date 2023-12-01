import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:senior_fitness_app/birth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Name extends StatefulWidget {
  const Name({Key? key}) : super(key: key);

  @override
  _NameState createState() => _NameState();
}

class _NameState extends State<Name> {
  TextEditingController controller1 = TextEditingController();
  stt.SpeechToText speech = stt.SpeechToText();
  bool isListening = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50.0,
            ),
            Text(
              "이름을 알려주세요",
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
                      fontSize: 20.0,
                    ),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(100.0, 0.0, 100.0, 0.0),
                  child: Column(
                    children: [
                      SizedBox(height: 40.0,),
                      TextField(
                        controller: controller1,
                        decoration: const InputDecoration(
                          labelText: '이름',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 300.0),
            Text(
              "눌러서 말하기",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: toggleListening,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150.0, 150.0),
                backgroundColor: Colors.lightBlueAccent,
                shape: CircleBorder(),
              ),
              child: Icon(
                isListening ? Icons.mic : Icons.mic_off,
                color: Colors.white,
                size: 60.0,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  prefs.setString('name', controller1.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => BirthDatePage(
                        name: controller1.text,
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
                  style: TextStyle(color: Colors.white, fontSize: 30.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void toggleListening() {
    if (!isListening) {
      startListening();
    } else {
      stopListening();
    }
  }

  void startListening() {
    if (!speech.isListening) {
      speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            setState(() {
              controller1.text = result.recognizedWords;
            });
          }
        },
      );
      setState(() {
        isListening = true;
      });
    }
  }

  void stopListening() {
    if (speech.isListening) {
      speech.stop();
      setState(() {
        isListening = false;
      });
    }
  }
}
