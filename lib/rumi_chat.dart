import 'package:flutter/material.dart';
import 'package:senior_fitness_app/chatbot.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:auto_size_text/auto_size_text.dart';


class rumi_chat extends StatefulWidget {
  const rumi_chat({super.key});

  @override
  State<rumi_chat> createState() => _rumi_chatState();
}

class _rumi_chatState extends State<rumi_chat> {
  FlutterTts flutterTts = FlutterTts();
  final List<ChatMessage> messages = []; // 채팅 메시지를 저장할 목록
  final TextEditingController _controller = TextEditingController();

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
                  content: messages[index].content,  // 수정: message -> content로 변경
                  isUser: messages[index].isUser,
                );
              },
            ),
          ),

          BottomAppBar(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Chatbot()),
                      );
                      // 여기에 메인으로 이동 버튼이 눌렸을 때의 동작 추가
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
                      '말동무로 이동',
                      style: TextStyle(color: Colors.white, fontSize: 30.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          BottomAppBar(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(hintText: '메시지를 입력하세요...'),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessage(_controller.text);
                  },
                ),
              ],
            ),
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
    final url = Uri.parse('https://6a87-175-214-183-100.ngrok.io');

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

        // 추가: 채팅 메시지 출력 여부 확인
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
