import 'dart:convert';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:skin_aid/Login/Login_page.dart';
import 'package:skin_aid/Main_App/AboutUs.dart';
import 'package:skin_aid/Main_App/DoctorList.dart';
import 'package:skin_aid/Main_App/Home_page.dart';
import 'package:skin_aid/Main_App/Profile_Page.dart';
import 'package:skin_aid/Main_App/SkinCare.dart';
import 'package:skin_aid/Main_App/chatbotApp.dart';

class InfoPage extends StatefulWidget {
  final String uid;
  InfoPage({required this.uid});

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  // Define expansion states for each section
  bool isScabiesExpanded = false;
  bool isEczemaExpanded = false;
  bool isPsoriasisExpanded = false;

  // State for symptom selection
  bool isSymptomsExpanded = true; // Start with symptoms expanded
  // List<String> selectedSymptoms = [];
  // List<String> allSymptoms = [
  //   'Itching',
  //   'Redness',
  //   'Rash',
  //   'Blisters',
  //   'Scaling',
  //   'Dryness',
  //   'Inflammation',
  //   'Pain',
  //   'Pus',
  //   'Hair loss',
  //   'Nail changes',
  // ];
  int _currentIndex = 0;

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to the selected page based on index
    switch (index) {
      case 0:
        // Navigate to info page
        Navigator.pushReplacement(
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
        // Navigate to profile page
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skin Disease Information'),
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 10.0),

            // ElevatedButton(
            //   onPressed: () {
            //     // Navigate to doctor list page (replace with your actual navigation)
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => DoctorListPage(
            //                 uid: '',
            //               )),
            //     );
            //   },
            //   child: Text('Show Doctor\'s List    >'),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor:
            //         Color(0xFF74546A), // Set button color (optional)
            //     foregroundColor: Color(0xFFFFEAEE), // Set text color (optional)
            //     shape: RoundedRectangleBorder(
            //       borderRadius:
            //           BorderRadius.circular(10.0), // Set border radius
            //     ),
            //   ),
            // ),
            SizedBox(height: 10.0),
            // Introduction to Skin Diseases
            _buildSection(
              title: 'What are Skin Diseases?',
              imagePath: 'images/skin_general.png', // Placeholder image
              description:
                  'Skin diseases are conditions that affect the skin, causing a variety of symptoms such as rashes, inflammation, itching, and more. They can be caused by various factors like infections, allergies, genetics, and immune system dysfunction.',
            ),
            SizedBox(height: 24.0),

            // Rest of the sections (Scabies, Eczema, Psoriasis)
            // ... (same as before)
            // Scabies Section
            _buildExpandableSection(
              title: 'Scabies',
              imagePath: 'images/scabies1.png',
              description:
                  'Scabies is a contagious skin condition caused by mites that burrow into the skin. Symptoms include intense itching, especially at night, and a pimple-like rash. Treatment typically involves medication and hygiene measures.',
              expandedContent: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\nSymptoms:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('- Intense itching, especially at night'),
                  Text('- Pimple-like rash'),
                  Text('- Sores caused by scratching'),
                  Text('- Red, inflamed skin'),
                  Text('- Itching worsens in warmer conditions'),
                  SizedBox(height: 12.0),
                  Text(
                    '\nTreatment:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('- Prescription scabicide creams or lotions'),
                  Text('- Oral medication in some cases'),
                  Text('- Cleaning and disinfecting clothing and bedding'),
                ],
              ),
              isExpanded: isScabiesExpanded,
              onTap: () {
                setState(() {
                  isScabiesExpanded = !isScabiesExpanded;
                });
              },
            ),
            SizedBox(height: 24.0),

            // Eczema Section
            _buildExpandableSection(
              title: 'Eczema',
              imagePath: 'images/eczema1.png',
              description:
                  'Eczema is a chronic skin condition characterized by red, itchy, and inflamed skin. Triggers may include allergens and stress.',
              expandedContent: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\nSymptoms:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('- Itchy, dry, and inflamed skin'),
                  Text('- Red or brownish patches'),
                  Text('- Blisters that may ooze and crust over'),
                  Text('- Thickened or scaly skin'),
                  Text('- Itching worsens at night'),
                  SizedBox(height: 12.0),
                  Text(
                    '\nTreatment:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('- Moisturizing creams or ointments'),
                  Text('- Topical corticosteroids for inflammation'),
                  Text('- Antihistamines for itching relief'),
                  Text('- Avoiding triggers like certain foods and stress'),
                ],
              ),
              isExpanded: isEczemaExpanded,
              onTap: () {
                setState(() {
                  isEczemaExpanded = !isEczemaExpanded;
                });
              },
            ),
            SizedBox(height: 24.0),

            // Psoriasis Section
            _buildExpandableSection(
              title: 'Psoriasis',
              imagePath: 'images/psoriases1.png',
              description:
                  'Psoriasis is an autoimmune disease that causes rapid skin cell growth, leading to thick, scaly patches on the skin. It can be triggered by stress and infections.',
              expandedContent: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\nSymptoms:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('- Thick, red patches with silvery scales'),
                  Text('- Dry, cracked skin that may bleed'),
                  Text('- Itching, burning, or soreness'),
                  Text('- Nail changes, like pitting or thickening'),
                  Text('- Joint pain or swelling in some cases'),
                  SizedBox(height: 12.0),
                  Text(
                    '\nTreatment:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                      '- Topical treatments like corticosteroids and coal tar'),
                  Text('- Phototherapy using UV light'),
                  Text('- Oral or injectable medications for severe cases'),
                  Text('- Lifestyle changes like stress management'),
                ],
              ),
              isExpanded: isPsoriasisExpanded,
              onTap: () {
                setState(() {
                  isPsoriasisExpanded = !isPsoriasisExpanded;
                });
              },
            ),
          ],
        ),
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

  // Widget _buildSymptomSelection() {
  //   return Container(
  //     padding: EdgeInsets.all(16.0),
  //     decoration: BoxDecoration(
  //       color: Color(0xFFF2F2F2), // Light gray background
  //       borderRadius: BorderRadius.circular(10.0),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         GestureDetector(
  //           onTap: () {
  //             setState(() {
  //               isSymptomsExpanded = !isSymptomsExpanded;
  //             });
  //           },
  //           child: Row(
  //             children: [
  //               Text(
  //                 'Select Symptoms (Max 5)',
  //                 style: TextStyle(
  //                   fontSize: 20.0,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               Icon(
  //                   isSymptomsExpanded ? Icons.expand_less : Icons.expand_more),
  //             ],
  //           ),
  //         ),
  //         SizedBox(height: 16.0),
  //         if (isSymptomsExpanded)
  //           Wrap(
  //             spacing: 8.0,
  //             children: allSymptoms.map((symptom) {
  //               bool isSelected = selectedSymptoms.contains(symptom);
  //               return FilterChip(
  //                 label: Text(symptom),
  //                 selected: isSelected,
  //                 onSelected: (value) {
  //                   setState(() {
  //                     if (value) {
  //                       if (selectedSymptoms.length < 5) {
  //                         selectedSymptoms.add(symptom);
  //                       } else {
  //                         // Show a snackbar or alert if trying to select more than 5
  //                         ScaffoldMessenger.of(context).showSnackBar(
  //                           SnackBar(
  //                             content: Text('You can select up to 5 symptoms.'),
  //                           ),
  //                         );
  //                       }
  //                     } else {
  //                       selectedSymptoms.remove(symptom);
  //                     }
  //                   });
  //                 },
  //               );
  //             }).toList(),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  // Section with expandable content
  Widget _buildExpandableSection({
    required String title,
    required String imagePath,
    required String description,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget expandedContent,
  }) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2), // Light gray background
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 200.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 16.0),
          Text(description),
          SizedBox(height: 16.0),
          // Show expanded content when tapped
          if (isExpanded) expandedContent,
        ],
      ),
    );
  }

  // Simple section with image and description
  Widget _buildSection({
    required String title,
    required String imagePath,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2), // Light gray background
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 200.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 16.0),
          Text(description),
        ],
      ),
    );
  }

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
