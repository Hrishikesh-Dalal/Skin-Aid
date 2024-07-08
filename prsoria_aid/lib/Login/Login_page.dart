import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:intl/intl.dart';
import 'package:skin_aid/Information_Page/User_Info.dart';
import 'package:skin_aid/Login/ForgotPassword.dart';
import '../Main_App/Home_page.dart';
import 'Phone_sign.dart';
import 'Sign_up.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      theme: ThemeData(
        primaryColor: Color(0xFF74546A),
        secondaryHeaderColor: Color(0xFFFFEAEE),
        fontFamily: 'Roboto',
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMessage = "";
  bool _obscureText = true;
  void login(BuildContext context) async {
    setState(() {
      errorMessage = ""; // Clear previous error message
    });

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = "Enter correct credentials";
      });
    } else {
      try {
        UserCredential userCred = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          String uid = user.uid;
          print('User UID: $uid');

          // Now you can directly navigate to the home page with the UID
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(
                uid: uid,
              ),
            ),
          );
        } else {
          print('User not signed in.');
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message ?? "An error occurred";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFEAEE),
        appBar: AppBar(
          title: Text(
            'Welcome',
            style: TextStyle(
              color: Colors.black, // Set title text color here
            ),
          ),
          backgroundColor: Color(0xFFFFEAEE),
        ), //0xFFF9E17E
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('images/logo.png'),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPassword()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Forgot Password?',
                        style: TextStyle(
                            color:
                                Color(0xFF74546A)), // Set the text color here
                      ),
                    ),
                  ),
                  SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: () {
                      login(context);
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Color(0xFFFFEAEE),
                          fontSize: 18,
                          backgroundColor: Color(0xFF74546A)),
                      // Set text color
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xFF74546A)), // Set background color
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Set border radius
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 16.0),
                      Container(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => SignUpPage()),
                              ),
                            );
                          },
                          child: Text(
                            'Create New Account',
                            style: TextStyle(
                                color: Color(0xFF74546A), // Text color
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 16), // Padding
                            ),
                            overlayColor: MaterialStateProperty.all<Color>(
                                Colors.transparent), // No overlay color
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (errorMessage.isNotEmpty)
                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                ],
              ),
            ),
          ),
        ));
  }
}
