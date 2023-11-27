import 'package:flutter/material.dart';
import 'package:senior_fitness_app/dashboard.dart';
import 'package:senior_fitness_app/rumi_chat.dart';
import 'package:contacts_service/contacts_service.dart';

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
          // 기존 버튼들
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildImageWithButton(), // 두 번째 버튼은 이미지가 들어간 버튼
              SizedBox(width: 20), // 기존 버튼들 간격 조절
              buildButton(), // 세 번째 버튼은 + 형태의 아이콘 버튼
            ],
          ),
          SizedBox(height: 20), // 첫 번째 행과 두 번째 행 간격 조절

          // 새로 추가된 버튼들
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20.0, // 수평 간격 조절
            runSpacing: 20.0, // 수직 간격 조절
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
                    MaterialPageRoute(builder: (context) => Dashboard()),
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

  void addNewButton(String contactName) {
    setState(() {
      buttons.add(buildButton(contactName));
    });
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
      child: Image.asset('images/rumi.png', width: buttonWidth, height: buttonWidth),
    );
  }

  Widget buildButton([String? contactName]) {
    return ElevatedButton(
      onPressed: () async {
        // 연락처 선택 기능 추가
        Contact? selectedContact = await _selectContact();
        if (selectedContact != null) {
          // 연락처가 선택되면 선택한 연락처의 이름으로 새로운 버튼 생성
          addNewButton(selectedContact.displayName ?? 'Unknown');
        }
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20),
        shape: CircleBorder(),
        primary: buttonColor,
      ),
      child: Icon(Icons.add, size: buttonWidth), // + 형태의 아이콘
    );
  }

  Future<Contact?> _selectContact() async {
    // 연락처 선택 로직 추가
    Iterable<Contact> contacts = await ContactsService.getContacts(withThumbnails: false);
    Contact? selectedContact = await showDialog<Contact>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a contact'),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              children: contacts.map((contact) => ListTile(
                title: Text(contact.displayName ?? 'Unknown'),
                onTap: () => Navigator.of(context).pop(contact),
              )).toList(),
            ),
          ),
        );
      },
    );
    return selectedContact;
  }
}
