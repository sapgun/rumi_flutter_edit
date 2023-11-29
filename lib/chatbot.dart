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
  Color buttonColor = Colors.lightBlueAccent;

  double buttonWidth = 100;

  List<Widget> buttons = [];

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildImageWithButton(),
              SizedBox(width: 20),
              buildButton(),
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
                  backgroundColor: Colors.lightBlueAccent,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  '메인으로 이동',
                  style: TextStyle(color: Colors.white, fontSize: 30.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addNewButton(String contactName) async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      setState(() {
        buttons.add(buildButton(contactName));
      });
    } else if (status.isDenied) {
      // 권한이 거부된 경우, 사용자에게 권한 요청 팝업을 띄우도록 처리
      await Permission.contacts.request();
      // 다시 권한 상태 확인 후 버튼 추가
      status = await Permission.contacts.status;
      if (status.isGranted) {
        setState(() {
          buttons.add(buildButton(contactName));
        });
      }
    } else if (status.isPermanentlyDenied) {
      // 영구적으로 권한이 거부된 경우, 설정으로 이동
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

  Widget buildButton([String? contactName]) {
    return ElevatedButton(
      onPressed: () async {
        Contact? selectedContact = await _selectContact();
        if (selectedContact != null) {
          addNewButton(selectedContact.displayName ?? 'Unknown');
          getPermission();
        }
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20),
        shape: CircleBorder(),
        primary: buttonColor,
      ),
      child: Icon(Icons.add, size: buttonWidth),
    );
  }

  Future<Contact?> _selectContact() async {
    Iterable<Contact> contacts =
        await ContactsService.getContacts(withThumbnails: false);
    Contact? selectedContact = await showDialog<Contact>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a contact'),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              children: contacts
                  .map((contact) => ListTile(
                        title: Text(contact.displayName ?? 'Unknown'),
                        onTap: () => Navigator.of(context).pop(contact),
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
    return selectedContact;
  }
}

getPermission() async {
  //(주의) Android 11버전 이상과 iOS에서는 유저가 한 두번 이상 거절하면 다시는 팝업 띄울 수 없습니다.
  var status = await Permission.contacts.status;
  if (status.isGranted) {
    //연락처 권한 줬는지 여부
    print('허락됨');

    ///썸네일제외한 연락처 가져오기
    var contacts = await ContactsService.getContacts(withThumbnails: false);
  } else if (status.isDenied) {
    print('거절됨');
    Permission.contacts.request(); //허락해달라고 팝업띄우는 코드
  }
  //하지만 아이폰의 경우 OS가 금지하는 경우도 있고 (status.isRestricted)
  (status.isPermanentlyDenied);
  if (status.isPermanentlyDenied) {
    openAppSettings();
  }
}
