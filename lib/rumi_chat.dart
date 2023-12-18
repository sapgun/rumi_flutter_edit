import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:senior_fitness_app/chatbot.dart';

class rumi_chat extends StatefulWidget {
  const rumi_chat({Key? key}) : super(key: key);

  @override
  State<rumi_chat> createState() => _rumi_chatState();
}

class _rumi_chatState extends State<rumi_chat> {
  FlutterTts flutterTts = FlutterTts();
  final List<ChatMessage> messages = []; // 채팅 메시지를 저장할 목록
  final TextEditingController _controller = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool isListening = false;

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
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Bubble(
                  content: messages[index].content,
                  isUser: messages[index].isUser,
                );
              },
            ),
          ),
          BottomAppBar(
            color: Color(0xff8EB3C7FF),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: '메시지를 입력하세요...',
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessage(_controller.text);
                  },
                ),
                GestureDetector(
                  onTapDown: (details) async {
                    if (!isListening) {
                      var available = await _speech.initialize();
                      if (available) {
                        setState(() {
                          isListening = true;
                        });
                        _speech.listen(
                          onResult: (result) {
                            setState(() {
                              _controller.text = result.recognizedWords;
                              print(_controller.text);
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
                    _speech.stop();
                  },
                  child: CircleAvatar(
                    backgroundColor: Color(0xFF1F4EF5),
                    radius: 30.0,
                    child: Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                      color: Colors.white,
                      size: 24.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5), // 추가된 간격
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 80), // 위로 올리고 싶은 만큼의 여유 공간 추가
              Container(
                width: 330.0,
                height: 60.0,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Chatbot()),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFF1F4EF5),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    '말동무로 이동',
                    style: TextStyle(color: Colors.white, fontSize: 30.0),
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  void sendMessage(String content) {
    setState(() {
      messages.add(ChatMessage(content, true));
    });

    sendToServer(content);

    _controller.clear();
  }

  Future<void> sendToServer(String userMessage) async {
    final url = Uri.parse('https://5358-211-215-32-91.ngrok.io');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userMessage': userMessage}),
      );

      print('서버 응답 데이터: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        String chatbotResponse = data['generated_text'] ?? '';

        print('챗봇 응답: $chatbotResponse');

        if (chatbotResponse.isNotEmpty) {
          setState(() {
            messages.add(ChatMessage(chatbotResponse, false));
          });
          await flutterTts.speak(chatbotResponse);
        } else {
          print('챗봇 응답이 비어있습니다.');
        }
      } else {
        print('서버 응답 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('서버 통신 중 오류 발생: $e');
    }
  }

  Future<void> listen() async {
    if (await _speech.initialize()) {
      _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            _controller.text = result.recognizedWords;
            sendMessage(result.recognizedWords);
          }
        },
      );
    } else {
      print('음성 인식 초기화에 실패했습니다.');
    }
  }
}

class ChatMessage {
  final String content;
  final bool isUser;

  ChatMessage(this.content, this.isUser);
}

class Bubble extends StatelessWidget {
  final String content;
  final bool isUser;

  const Bubble({required this.content, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset(
                'images/rumi.png',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue : Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (content.startsWith('image:'))
                    Image.asset(
                      'images/${content.substring(6)}',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  else
                    Text(
                      content,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
