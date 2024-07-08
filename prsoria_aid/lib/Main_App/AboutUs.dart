import 'dart:convert';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skin_aid/Main_App/DoctorList.dart';
import 'package:skin_aid/Main_App/Home_page.dart';
import 'package:skin_aid/Main_App/Profile_Page.dart';
import 'package:skin_aid/Main_App/chatbotApp.dart';

class about_us extends StatefulWidget {
  // final String uid;
// InfoPage({required this.uid});

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<about_us> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        backgroundColor: Color(0xFFFFEAEE),
        automaticallyImplyLeading: true,
      ),
// <<<<<<< HEAD
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mission Section
              Text(
                'Mission :\n',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Our mission is to develop a cutting-edge, user-friendly application that empowers individuals to take control of their skin health. By combining deep learning models with an intuitive user interface, we aim to provide accurate and timely feedback on skin conditions, enabling users to make informed decisions about their healthcare.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20),

              // Vision Section
              Text(
                'Vision :\n',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Our vision is to revolutionize the way people approach skin health by creating an accessible, reliable, and comprehensive platform. We strive to foster a community of informed and proactive users who can effectively manage their skin conditions and contribute to a broader understanding of skin health issues.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20),

              // Contact Us Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Us:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Card for Partnerships
                        Container(
                          width: MediaQuery.of(context).size.width *
                              0.43, // Adjust width as needed
                          child: Card(
                            elevation: 3,
                            color: Color(0xFFFFEAEE),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.business,
                                    size: 40,
                                    color: Color(0xFF74546A),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Partnerships',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF74546A),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '+9876543210\npartnerships@skinaid.com',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF74546A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20), // Add spacing between cards
                        // Card for Complaints
                        Container(
                          width: MediaQuery.of(context).size.width *
                              0.43, // Adjust width as needed
                          child: Card(
                            elevation: 3,
                            color: Color(0xFFFFEAEE),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.report_problem,
                                    size: 40,
                                    color: Color(0xFF74546A),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Complaints',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF74546A),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '+1234567890\ncomplaints@skinaid.com',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF74546A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20), // Add spacing between cards
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
// About Us Section
              Text(
                'About Us :',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: RichText(
                    textAlign:
                        TextAlign.justify, // Apply text justification here
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text:
                              'SkinAid is a smart and innovative application designed to help users monitor their skin health. By leveraging advanced deep learning models and a user-friendly interface, SkinAid provides accurate and instant feedback on various skin conditions, including psoriasis, eczema, and scabies. The app also offers personalized treatment guidance, early detection of skin diseases, and a wealth of educational resources to empower users with knowledge for proactive management.\n\n',
                        ),
                        TextSpan(
                          text: 'Key Features:\n\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              '- Real-time Analysis: SkinAid\'s deep learning model enables instant and accurate feedback on users\' skin conditions, facilitating quick awareness and understanding.\n'
                              '- Treatment Guidance: The app offers personalized guidance on potential treatments and management strategies based on the specific type of psoriasis detected.\n'
                              '- Early Detection: SkinAid identifies different psoriasis types through the app for timely intervention, fostering better health outcomes.\n'
                              '- Educational Resource: The app provides comprehensive and accessible information on psoriasis types, causes, symptoms, and available treatments, empowering users with knowledge for proactive management.\n\n',
                        ),
                        // TextSpan(
                        //   text: 'Assumptions:\n\n',
                        //   style: TextStyle(fontWeight: FontWeight.bold),
                        // ),
                        // TextSpan(
                        //   text:
                        //       '- Users are expected to submit well-lit and clear images to ensure accurate analysis of their skin conditions.\n'
                        //       '- A stable internet connection is necessary for seamless communication and data transfer between the user\'s device and the application\'s servers.\n'
                        //       '- Users are required to have either an email address or phone number to register and access the full functionality of the application.\n\n',
                        // ),
                        // TextSpan(
                        //   text: 'Constraints :\n\n',
                        //   style: TextStyle(fontWeight: FontWeight.bold),
                        // ),
                        // TextSpan(
                        //   text:
                        //       '- Diagnostic Accuracy: The app does not guarantee the presence of diseases. Diagnostic accuracy is contingent upon image quality, and users should exercise caution when interpreting information.\n'
                        //       '- Image Quality Requirement: For accurate results, images should adhere to a standard size of approximately 224 by 224 pixels. Images that are either too zoomed in or too zoomed out may produce inaccurate outputs.\n'
                        //       '- Internet Connection Requirement: The app requires an active internet connection for proper functionality.\n'
                        //       '- Platform Compatibility: The app is only compatible with Android devices and does not function on iOS.\n'
                        //       '- Supported Diseases: The app is designed to interpret specific diseases, including scabies, psoriasis, and eczema. Other diseases may result in incorrect outputs.\n\n',
                        // ),
                        // TextSpan(
                        //   text:
                        //       'By focusing on user-centric design, advanced deep learning models, and comprehensive educational resources, SkinAid aims to become a trusted partner in users\' skin health journey, fostering a community of informed, proactive, and empowered individuals.',
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
// =======
// >>>>>>> 461e66d6ae53bd84e05338ac648287966e637634
    );
  }
}
