import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:senior_fitness_app/birth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avatar_glow/avatar_glow.dart';

class Name extends StatefulWidget {
  const Name({Key? key}) : super(key: key);

  @override
  _NameState createState() => _NameState();
}

class _NameState extends State<Name> {
  var text = "";
  var isListening = false;
  SpeechToText speechToText = SpeechToText();
  TextEditingController controller1 = TextEditingController();
  SpeechToText speech = SpeechToText();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
            // Text(
            //   "눌러서 말하기",
            //   style: TextStyle(
            //     fontSize: 20.0,
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 125.0,
        animate: isListening,
        duration: Duration(milliseconds: 2000),
        glowColor: Color(0xFF1F4EF5),
        repeat: true,
        repeatPauseDuration: Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          onTapDown: (details) async {
            if (!isListening) {
              var available = await speechToText.initialize();
              if (available) {
                setState(() {
                  isListening = true;
                });
                speechToText.listen(
                  onResult: (result) {
                    setState(() {
                      controller1.text = result.recognizedWords;
                      print(controller1.text);
                    });
                  },
                );
              }
            }
          },
          onTapUp: (details) {
            setState(() {
              isListening = false;
            });
            speechToText.stop();
          },
          child: CircleAvatar(
            backgroundColor: Color(0xFF1F4EF5),
            radius: 100.0,
            child: Icon(isListening ? Icons.mic : Icons.mic_none, color: Colors.white, size: 75.0,),
          ),
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
                  backgroundColor: Color(0xFF1F4EF5),
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
}
