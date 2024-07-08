import 'dart:convert';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:skin_aid/Login/Login_page.dart';
import 'package:skin_aid/Main_App/AboutUs.dart';
import 'package:skin_aid/Main_App/DoctorList.dart';
import 'package:skin_aid/Main_App/Home_page.dart';
import 'package:skin_aid/Main_App/Info_page.dart';
import 'package:skin_aid/Main_App/Profile_Page.dart';
import 'package:skin_aid/Main_App/chatbotApp.dart';

class SkinCare extends StatefulWidget {
  final String uid;
  SkinCare({required this.uid});

  @override
  _SkinPageState createState() => _SkinPageState();
}

class _SkinPageState extends State<SkinCare> {
  @override
  Widget build(BuildContext context) {
    int _currentIndex = 3;
    int currentIndex = 3;
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
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatBotApp(
                        uid: widget.uid,
                      )));
          break;
        case 3:
          // Navigator.pushReplacement(
          //     // Navigate to doc page
          //     // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => SkinCare(
          //               uid: widget.uid,
          //             )));
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Skin Care'),
        backgroundColor: Color(0xFFFFEAEE),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.settings,
              color: Color(0xFF74546A), // Change the color of the icon here
            ),
            onSelected: (value) {
              switch (value) {
                case 'Profile':
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(
                                uid: widget.uid,
                              )));
                  break;
                case 'about_us':
                  //  onPressed: () {
                  // Navigate to doctor list page (replace with your actual navigation)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => about_us(
                            // uid: '',
                            )),
                  );
                  // },
                  break;
                case 'logout':
                  logout();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Profile',
                child: Text('Profile'),
              ),
              PopupMenuItem(
                value: 'about_us',
                child: Text('About Us'), // Update text dynamically
              ),
              PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
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
            Icons.favorite,
            color: Color(0xFFFFEAEE),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  // int _currentIndex = 1;
  // Index of the selected bottom navigation bar item
  void logout() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    // Check if the current user signed in with Google
    bool isGoogleUser = false;
    if (_auth.currentUser != null) {
      for (UserInfo userInfo in _auth.currentUser!.providerData) {
        if (userInfo.providerId == 'google.com') {
          isGoogleUser = true;
          break;
        }
      }
    }

    // Disconnect Google account if it's a Google user
    if (isGoogleUser) {
      await _googleSignIn.disconnect();
    }

    // Sign out from Firebase
    await _auth.signOut();

    // Navigate to the login page
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
