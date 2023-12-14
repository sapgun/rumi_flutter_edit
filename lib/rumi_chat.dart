import 'package:flutter/material.dart';
import 'package:senior_fitness_app/chatbot.dart';

class rumi_chat extends StatefulWidget {
  const rumi_chat({super.key});

  @override
  State<rumi_chat> createState() => _rumi_chatState();
}

class _rumi_chatState extends State<rumi_chat> {
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
                return ListTile(
                  title: Text(
                    messages[index].content,
                    style: TextStyle(
                      color: messages[index].isUser ? Colors.blue : Colors.green,
                    ),
                  ),
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

  void sendToServer(String userMessage) {
    // 사용자 메시지를 Flask 서버로 보내고 응답을 처리하는 로직을 구현
    // 실제로는 HTTP 요청 등을 사용할 것입니다.

    String chatbotResponse = getChatbotResponse(userMessage);

    setState(() {
      messages.add(ChatMessage(chatbotResponse, false));
    });
  }

  String getChatbotResponse(String userMessage) {
    // 사용자 메시지를 Flask 서버로 전송하고 챗봇 응답을 받는 로직을 구현
    // 실제로는 HTTP 요청 등을 사용할 것입니다.

    // 간단함을 위해 현재는 정적인 응답을 반환
    return "루미: 받은 메시지: '$userMessage'";
  }

}

class ChatMessage {
  final String content;
  final bool isUser;

  ChatMessage(this.content, this.isUser);
}
