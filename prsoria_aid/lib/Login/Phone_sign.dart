import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'Verify_otp.dart';

class Phone_signin extends StatefulWidget {
  const Phone_signin({super.key});

  @override
  State<Phone_signin> createState() => _Phone_signinState();
}

class _Phone_signinState extends State<Phone_signin> {
  TextEditingController phoneController = TextEditingController();

  void signin() async {
    String phone_txt = "+91" + phoneController.text.trim();
    // int phone_num = int.parse(phone_txt);
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone_txt,
        codeSent: (verificationId, resendToken) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OTPSignin(
                        verificationId: verificationId,
                      )));
        },
        verificationCompleted: (credential) {},
        verificationFailed: (ex) {
          print(ex.toString());
        },
        codeAutoRetrievalTimeout: (verifcationId) {},
        timeout: Duration(seconds: 30));
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
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
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
                signin();
              },
              color: Color(0xFF74546A),
              child:
                  Text('Sign In', style: TextStyle(color: Color(0xFFFFEAEE))),
            ),
          ],
        ),
      ),
    );
  }
}
