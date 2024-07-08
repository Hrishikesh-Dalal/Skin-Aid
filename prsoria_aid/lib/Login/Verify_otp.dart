import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:skin_aid/Information_Page/User_Info.dart';

import '../Main_App/Home_page.dart';

class OTPSignin extends StatefulWidget {
  final String verificationId;
  const OTPSignin({super.key, required this.verificationId});

  @override
  State<OTPSignin> createState() => _OTPSigninState();
}

class _OTPSigninState extends State<OTPSignin> {
  TextEditingController otpController = TextEditingController();

  void verify() async {
    String otp = otpController.text.trim();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otp);
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String uid = user.uid;
        print('User UID: $uid');

        // Check for document existence before creating
        FirebaseFirestore.instance
            .collection(uid)
            .doc('def')
            .get()
            .then((docSnapshot) {
          if (!docSnapshot.exists) {
            // Document doesn't exist, create it
            FirebaseFirestore.instance.collection(uid).doc('def').set(
              {'count': 0},
              SetOptions(merge: false),
            ).then((_) {
              print('Collection and document created successfully.');
            }).catchError((error) {
              print('Error creating collection and document: $error');
            });
          } else {
            print('Document already exists.');
          }
        });
      } else {
        print('User not signed in.');
      }

      if (userCredential != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserProfileScreen(
                      uid: user!.uid,
                    )));
      }
    } on FirebaseAuthException catch (ex) {
      print(ex.code.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email field
            TextField(
              controller: otpController,
              maxLength: 6,
              decoration: InputDecoration(labelText: 'OTP'),
            ),
            SizedBox(height: 16.0),

            // Text(
            //   print_me,
            //   style: TextStyle(
            //     color: Colors.red,
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // Sign In button
            CupertinoButton(
              onPressed: () {
                verify();
              },
              color: Color(0xFF74546A),
              child: Text('Verify', style: TextStyle(color: Color(0xFFFFEAEE))),
            ),
          ],
        ),
      ),
    );
  }
}
