// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Login/Login_page.dart';
import 'Main_App/Home_page.dart';
import 'firebase_options.dart';
// import 'package:kommunicate_flutter/kommunicate_flutter.dart';
//import 'dart:ui';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("Habit_Database");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null)
          ? Home(
              uid: FirebaseAuth.instance.currentUser!.uid,
            )
          : LoginPage(),
    );
  }
}
