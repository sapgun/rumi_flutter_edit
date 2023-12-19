import 'package:flutter/material.dart';
import 'package:senior_fitness_app/dashboard.dart';
import 'package:senior_fitness_app/rumi_chat.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:senior_fitness_app/loading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({Key? key}) : super(key: key);

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  Color backgroundColor = Colors.white;
  Color buttonColor = Colors.lightBlue;
  double buttonWidth = 100;
  List<Widget> buttons = [];
  Contact? selectedContact; // 추가: 선택된 연락처를 저장할 변수

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  void getPermission() async {
    //(주의) Android 11버전 이상과 iOS에서는 유저가 한 두번 이상 거절하면 다시는 팝업 띄울 수 없습니다.
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      //연락처 권한 줬는지 여부
      print('허락됨');
    } else if (status.isDenied) {
      print('거절됨');
      await Permission.contacts.request(); //허락해달라고 팝업띄우는 코드
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100), // 여기에 추가
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildImageWithButton(),
                SizedBox(width: 20),
                buildButton(contactName: 'SomeContactName'),
              ],
            ),
            SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20.0,
              runSpacing: 20.0,
              children: buttons,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Loading()),
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
                  '처음으로 이동',
                  style: TextStyle(color: Colors.white, fontSize: 30.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addNewButton(Contact selectedContact, String? contactName) async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      setState(() {
        buttons.add(buildContactButton(selectedContact, contactName));
      });
    } else if (status.isDenied) {
      await Permission.contacts.request();
      status = await Permission.contacts.status;
      if (status.isGranted) {
        setState(() {
          buttons.add(buildContactButton(selectedContact, contactName));
        });
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }


  Widget buildImageWithButton() {
    return ElevatedButton(
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => rumi_chat()),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20),
        shape: CircleBorder(),
        primary: buttonColor,
      ),
      child: Image.asset('images/rumi.png',
          width: buttonWidth, height: buttonWidth),
    );
  }

  Widget buildButton({String? contactName}) {
    return ElevatedButton(
      onPressed: () async {
        Contact? selectedContact = await _selectContact();
        if (selectedContact != null) {
          addNewButton(selectedContact, contactName);
        }
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20),
        shape: CircleBorder(),
        primary: buttonColor,
      ),
      child: Icon(Icons.add, size: buttonWidth, color: Colors.white),
    );
  }


  Future<Contact?> _selectContact() async {
    Iterable<Contact> contacts = await ContactsService.getContacts(
      withThumbnails: false,
    );
    Contact? selectedContact = await showDialog<Contact>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('연락처 선택'),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              children: contacts.map(
                    (contact) => ListTile(
                  title: Text(contact.displayName ?? 'Unknown'),
                  onTap: () {
                    Navigator.of(context).pop(contact);
                  },
                ),
              ).toList(),
            ),
          ),
        );
      },
    );
    return selectedContact;
  }

  Widget buildContactButton(Contact contact, String? contactName) {
    String displayName = contact.displayName ?? contactName ?? 'Unknown';

    ButtonStyle originalButtonStyle = ElevatedButton.styleFrom(
      padding: EdgeInsets.all(20),
      shape: CircleBorder(),
      primary: buttonColor,
    );

    return Stack(
      alignment: Alignment.topRight,
      children: [
        ElevatedButton(
          onPressed: () {
            print('선택된 연락처: $displayName');
            String phoneNumber = contact.phones?.isNotEmpty ?? false
                ? contact.phones!.first.value!
                : '';
            _makePhoneCall(phoneNumber);
          },
          style: originalButtonStyle.merge(
            ButtonStyle(
              fixedSize: MaterialStateProperty.all(
                Size(140, 140),
              ),
            ),
          ),
          child: Text(
            displayName,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        IconButton(
          onPressed: () {
            _removeButton(contact);
          },
          icon: Icon(Icons.delete),
          color: Colors.red,
        ),
      ],
    );
  }

  void _removeButton(Contact contact) {
    String displayName = contact.displayName ?? 'Unknown';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('삭제 확인'),
          content: Text('연락처 "$displayName"를 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기

                setState(() {
                  buttons.removeWhere((widget) {
                    if (widget is Stack &&
                        widget.children.isNotEmpty &&
                        widget.children[0] is ElevatedButton) {
                      ElevatedButton elevatedButton = widget.children[0] as ElevatedButton;
                      Widget? child = elevatedButton.child;

                      if (child != null && child is Text) {
                        String buttonLabel = child.data ?? '';
                        return buttonLabel == displayName;
                      }
                    }
                    return false;
                  });

                });

                print('After UI deletion: $buttons');
              },
              child: Text('확인'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    if (await canLaunch('tel:$phoneNumber')) {
      await launch('tel:$phoneNumber');
    } else {
      print('Could not launch $phoneNumber');
    }
  }

  // _ChatbotState 클래스에 이 메서드를 추가하세요
  void sendMessageToServer(String userMessage) {
    // 사용자 메시지를 Flask 서버로 보내고 응답을 처리하는 로직을 구현
    // 예를 들어, HTTP 요청을 사용할 수 있음.

    // 간단함을 위해 `getChatbotResponse` 함수가 구현되어 있다고 가정
    // 실제 구현으로 대체하세요.
    String chatbotResponse = getChatbotResponse(userMessage);

    // 챗봇 응답을 UI에 표시
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('루미 대화'),
          content: Text(chatbotResponse),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 대화 상자 닫기
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

// _ChatbotState 클래스에 이 메서드를 추가하세요
  String getChatbotResponse(String userMessage) {
    // 사용자 메시지를 Flask 서버로 전송하고 챗봇 응답을 받는 로직을 구현
    // 예를 들어, HTTP 요청을 사용할 수 있음.

    // 간단함을 위해 현재는 정적인 응답을 반환
    return "루미: 안녕하세요! 받은 메시지: '$userMessage'";
  }


}

