import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:intl/intl.dart';
import 'package:skin_aid/Information_Page/User_Info.dart';
import '../Main_App/Home_page.dart';
import 'Phone_sign.dart';
import 'Sign_up.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Controller for text fields
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();
  String print_me = "";
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  void googleSignIn(BuildContext context) async {
    String errorMessage = "";
    setState(() {
      errorMessage = ""; // Clear previous error message
    });

    try {
      GoogleSignInAccount? g_user = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? g_auth = await g_user?.authentication;

      AuthCredential g_cred = GoogleAuthProvider.credential(
        accessToken: g_auth?.accessToken,
        idToken: g_auth?.idToken,
      );

      UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(g_cred);
      User? user_cur = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String uid = user_cur!.uid;
        print('User UID: $uid');

        // Check for document existence before creating
        FirebaseFirestore.instance
            .collection(uid)
            .doc('def')
            .get()
            .then((docSnapshot) {
          if (!docSnapshot.exists) {
            print("Doc does not exist");
            // Document doesn't exist, redirect to UserProfileScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfileScreen(uid: uid),
              ),
            );
          } else {
            print('Document already exists.');
            // Document exists, redirect to Home
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(uid: uid),
              ),
            );
          }
        });
      } else {
        print('User not signed in.');
      }
    } on MissingPluginException catch (ce) {
      setState(() {
        errorMessage = ce.toString();
      });
    }
  }

  void create_user() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cpassword = cpasswordController.text.trim();

    if (email == "" || password == "" || cpassword == "") {
      setState(() {
        print_me = "Please Enter all details";
      });
      print("Please Enter all details");
    } else if (password != cpassword) {
      setState(() {
        print("Enter correct passwords");
      });

      print_me = "enter correct passwords";
    } else {
      try {
        UserCredential userCred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        print("User Created");
        if (userCred.user != null) {
          // Navigator.pop(context);
          UserCredential userCred = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);
          User? user = FirebaseAuth.instance.currentUser;

          if (user != null) {
            String uid = user.uid;
            print('User UID: $uid');
            // Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => UserProfileScreen(
                        uid: uid,
                      )),
            );
          }
        } else {
          print('User not signed in.');
        }
      } on FirebaseAuthException catch (e) {
        print(e.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFEAEE),
        appBar: AppBar(
          backgroundColor: Color(0xFFFFEAEE),
          title: Text('Sign In'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Email field
                  SizedBox(height: 16.0),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  // Password field
                  SizedBox(height: 16.0),
                  TextField(
                    controller: passwordController,
                    obscureText: _obscureText1,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText1
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscureText1 = !_obscureText1;
                          });
                        },
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  // Confirm Password field
                  SizedBox(height: 16.0),
                  TextField(
                    controller: cpasswordController,
                    obscureText: _obscureText2,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText2
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscureText2 = !_obscureText2;
                          });
                        },
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Text(
                    print_me,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Sign In button
                  CupertinoButton(
                    onPressed: () {
                      // Handle sign in logic here
                      String email = emailController.text;
                      String password = passwordController.text;
                      String confirmPassword = cpasswordController.text;

                      // Perform sign in validation and processing
                      // Add your authentication logic here

                      // Example: Just print the values for demonstration
                      print('Email: $email');
                      print('Password: $password');
                      print('Confirm Password: $confirmPassword');
                      create_user();
                    },
                    color: Color(0xFF74546A),
                    child: Text('Sign In',
                        style:
                            TextStyle(color: Color(0xFFFFEAEE), fontSize: 18)),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => Phone_signin())),
                        );
                      },
                      child: Text(
                        'Sign in with Phone',
                        style:
                            TextStyle(color: Color(0xFFFFEAEE), fontSize: 17),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF74546A), // Background color
                        padding:
                            EdgeInsets.symmetric(vertical: 14.0), // Padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Button border radius
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        googleSignIn(context);
                        print("Google Sign in");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/google_logo.png', // Path to your Google logo image
                            height: 24, // Adjust the height as needed
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Sign in with Google',
                            style: TextStyle(
                              color: Color(0xFFFFEAEE),
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF74546A), // Background color
                        padding:
                            EdgeInsets.symmetric(vertical: 14.0), // Padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Button border radius
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

void main() {
  runApp(MaterialApp(
    home: SignUpPage(),
  ));
}
