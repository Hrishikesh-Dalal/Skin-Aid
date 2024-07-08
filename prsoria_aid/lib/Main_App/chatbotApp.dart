import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';
import 'package:skin_aid/Main_App/DoctorList.dart';
import 'package:skin_aid/Main_App/Home_page.dart';
import 'package:skin_aid/Main_App/Info_page.dart';
import 'package:skin_aid/Main_App/Profile_Page.dart';
import 'package:skin_aid/Main_App/SkinCare.dart';

// import 'package:flutter/material.dart';
// import 'package:kommunicate_flutter/kommunicate_flutter.dart';

class ChatBotApp extends StatefulWidget {
  final String uid;

  const ChatBotApp({Key? key, required this.uid}) : super(key: key);

  @override
  _ChatBotAppState createState() => _ChatBotAppState();
}

class _ChatBotAppState extends State<ChatBotApp> {
  int _currentIndex = 2;
  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to the selected page based on index
    switch (index) {
      case 0:
        // Navigate to info page
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InfoPage(
                      uid: widget.uid,
                    )));
        //Navigator.push( context, MaterialPageRoute(builder: (context) => InfoPage()));

        break;
      case 1:
        // Navigate to camera page
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                      uid: widget.uid,
                    )));
        // Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage()));
        break;
      case 2:
        // Navigate to chatbot
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatBotApp(
                      uid: widget.uid,
                    )));
        break;
      // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
      // break;
      case 3:
        // Navigate to doc page
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DoctorListPage(
                      uid: widget.uid,
                    )));
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    openChatbot();
  }

  void openChatbot() async {
    try {
      var conversationObject = {
        'appId': '334d2b029b5b828d48ce2673f3809997e',
        'agentId': ['venishakalola@gmail.com'],
        'botIds': ['skinaid-rvb9w'],
      };
      dynamic result =
          await KommunicateFlutterPlugin.buildConversation(conversationObject);
      print('Chatbot opened: $result');
    } catch (e) {
      print('Error opening chatbot: $e');
      // Handle the error here, e.g., show a snackbar or navigate to an error screen.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SkinAid ChatBot'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text('Welcome to SkinAid ChatBot\n     I am here to help you'),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color(0x00000000),
        color: Color(0xFF74546A),
        animationDuration: Duration(milliseconds: 300),
        // currentIndex: _currentIndex,
        index: _currentIndex,
        onTap: _onNavItemTapped,
        items: [
          // Icon(icon)
          Icon(
            Icons.info,
            color: Color(0xFFFFEAEE),
          ),
          Icon(
            Icons.camera,
            color: Color(0xFFFFEAEE),
          ),
          Icon(
            Icons.message_outlined,
            color: Color(0xFFFFEAEE),
          ),
          Icon(
            Icons.local_hospital_rounded,
            color: Color(0xFFFFEAEE),
          ),
        ],
      ),
    );
  }
}


  // Future<void> authenticateUser() async {
  //   const String appID =
  //       '334d2b029b5b828d48ce2673f3809997e'; // Your Kommunicate App ID

  //   // Check if the user is already logged in
  //   bool isLoggedIn = await KommunicateFlutterPlugin.isLoggedIn();

  //   if (!isLoggedIn) {
  //     // If not logged in, login as a visitor
  //     await KommunicateFlutterPlugin.loginAsVisitor(appID);
  //   } else {
  //     // If logged in, open the chatbot and send a welcome message
  //     await KommunicateFlutterPlugin.openConversations();
  //     await KommunicateFlutterPlugin.sendMessage(
  //         'Hello , from SkinAid - please feel free to ask anything you would like to know about skin diseases 😊');
  //   }
  // }

