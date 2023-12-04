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
      child: Icon(Icons.add, size: buttonWidth),
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

    // 원래 + 버튼의 스타일을 가져와서 새로운 버튼에 적용
    ButtonStyle originalButtonStyle = ElevatedButton.styleFrom(
      padding: EdgeInsets.all(20),
      shape: CircleBorder(),
      primary: buttonColor,
    );

    return ElevatedButton(
      onPressed: () {
        print('Selected Contact: $displayName');
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
        style: TextStyle(fontSize: 20),
      ),
    );
  }





  void _makePhoneCall(String phoneNumber) async {
    if (await canLaunch('tel:$phoneNumber')) {
      await launch('tel:$phoneNumber');
    } else {
      print('Could not launch $phoneNumber');
    }
  }
}

