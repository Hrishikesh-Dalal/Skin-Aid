import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:skin_aid/Main_App/AboutUs.dart';
import 'package:skin_aid/Main_App/DoctorList.dart';
import 'package:skin_aid/Main_App/Info_page.dart';
import 'package:skin_aid/Main_App/Profile_Page.dart';
import 'package:skin_aid/Main_App/Result_Page.dart';
import 'package:skin_aid/Main_App/SkinCare.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
// import 'image/src/image/image.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skin_aid/Main_App/Home_page.dart';
import 'package:skin_aid/Main_App/Info_page.dart';
import 'package:skin_aid/Main_App/Profile_Page.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';

import 'package:image/image.dart' as img;
import 'dart:math' as math;

import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:uuid/uuid.dart';
import 'chatbotApp.dart';
import '../Login/Login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class Home extends StatefulWidget {
  final String uid;
  // const Home({Key? key}) : super(key: key);
  const Home({super.key, required this.uid});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 1;
  File? profilepic;
  double _progress = 0.0;
  late Interpreter _interpreter; // Declare the interpreter instance

  String _classification = ''; // String to hold the prediction result
  double _confidenceScore = 0.0;
  late int predictedClass;
  late double modelConfidenceScore;

  @override
  void initState() {
    super.initState();
    // Initialize the interpreter here
    _initializeInterpreter();
  }

  void _initializeInterpreter() async {
    try {
      final interpreterOptions = InterpreterOptions();
      _interpreter = await Interpreter.fromAsset('assets/model_unquant.tflite',
          options: interpreterOptions);
    } catch (e) {
      print('Failed to initialize interpreter: $e');
    }
  }

  Future<void> _loadTFLiteModel() async {
    try {
      // Load the TensorFlow Lite model from assets
      _interpreter = await Interpreter.fromAsset('assets/model_unquant.tflite');
      // Allocate tensors for inference (call without expecting a return value)
      _interpreter.allocateTensors();
      print('Model loaded successfully!');
    } catch (e) {
      print('Error loading TFLite model: $e');
    }
  }

  Future<void> _runInference(File imageFile) async {
    try {
      if (_interpreter == null || !_interpreter.isAllocated) {
        await _loadTFLiteModel();
      }

      _interpreter.allocateTensors();

      final inputDetails = _interpreter.getInputTensors();
      final ByteData imageBytes = await imageFile
          .readAsBytes()
          .then((bytes) => ByteData.view(Uint8List.fromList(bytes).buffer));
      final preprocessedImageData = await _preprocessImage(imageBytes);
      final output = List.filled(1 * 4, 0.0).reshape([1, 4]);

      _interpreter.run(preprocessedImageData, output);

      print("output : $output");

      String classification;
      final List<double> probabilities = output[0] as List<double>;
      int predictedIndex = probabilities
          .asMap()
          .entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
      final confidenceScore = probabilities[predictedIndex];
      classification =
          'Class: $predictedIndex, Confidence: ${(confidenceScore * 100).toStringAsFixed(2)}%';
      print(classification);

      setState(() {
        _classification = classification;
        _confidenceScore = confidenceScore;
        modelConfidenceScore = confidenceScore;
        predictedClass = predictedIndex;
      });
    } catch (e) {
      print('Error running inference: $e');
    }
  }

  Future<List<List<List<List<double>>>>> _preprocessImage(
      ByteData imageBytes) async {
    // Define image dimensions
    const int IMAGE_WIDTH = 224;
    const int IMAGE_HEIGHT = 224;
    const int IMAGE_CHANNELS = 3;
    // Define target dimensions (match your model's requirements)
    const int TARGET_WIDTH = 224;
    const int TARGET_HEIGHT = 224;

    img.Image? image = img.decodeImage(Uint8List.view(imageBytes.buffer));

    img.Image resizedImage = img.copyResize(
      image!,
      width: TARGET_WIDTH,
      height: TARGET_HEIGHT,
    );

    // Apply Lanczos filter to the resized image
    // img.Image lanczosResizedImage = img.copyResize(
    //   resizedImage,
    //   width: TARGET_WIDTH,
    //   height: TARGET_HEIGHT,
    //   filter: img.FilterType.lanczos,
    // );
    // Initialize a 4-dimensional list array to hold the pixel values
    List<List<List<List<double>>>> inputValues = List.generate(
        1,
        (index) => List.generate(
            IMAGE_HEIGHT,
            (index) => List.generate(IMAGE_WIDTH,
                (index) => List.generate(IMAGE_CHANNELS, (index) => 0.0))));

    // Iterate over each pixel in the image to extract RGB values
    for (int y = 0; y < IMAGE_HEIGHT; y++) {
      for (int x = 0; x < IMAGE_WIDTH; x++) {
        final img.Pixel pixel = resizedImage.getPixel(x, y);
        // Extract RGB values from the pixel
        final double red = pixel.r / 255.0;
        final double green = pixel.g / 255.0;
        final double blue = pixel.b / 255.0;

        // Assign RGB values to the corresponding position in the inputValues list array
        inputValues[0][y][x] = [red, green, blue];
      }
    }
    print(inputValues);
    return inputValues;
  }

  void submitData() async {
    String uid = widget.uid;
    print(uid);
    if (profilepic != null) {
      print("Profile pic is not null");
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("profilepic")
          .child(Uuid().v1())
          .putFile(profilepic!);
      StreamSubscription transfer = uploadTask.snapshotEvents.listen((event) {
        double percentage = event.bytesTransferred / event.totalBytes * 100;
        print(percentage);

        setState(() {
          _progress = percentage;
        });
        // });
      });

      TaskSnapshot taskSnap = await uploadTask;
      String downloadurl = await taskSnap.ref.getDownloadURL();

      transfer.cancel();

      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection(uid).doc("def").get();

      // Check if the document exists
      if (snapshot.exists) {
        int count = (snapshot.data() as Map<String, dynamic>?)?['count'] ?? 0;
        // Default to 0 if 'count' is not available
        count++; // Increment count

        // Use count as the new document name
        Map<String, dynamic> user = {
          // your user data here
          "pic": downloadurl,
          "uploadDate": DateFormat('dd-MM-yyyy').format(DateTime.now()),
          "time": TimeOfDay.now().format(context).toString(),
          "result": "",
          "probability": 0.0
        };

        // Update the "def" document with the new count
        await FirebaseFirestore.instance
            .collection(uid)
            .doc("def")
            .update({'count': count});

        // Add user data with the new count as the document name
        await FirebaseFirestore.instance
            .collection(uid)
            .doc(count.toString())
            .set(user);
        profilepic = null;
        setState(() {
          _progress = 0.0;
        });
        // Example from Home widget's submitData() function
        // if (profilepic != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              uid: widget.uid,
              image: downloadurl,
              modelConfidenceScore: modelConfidenceScore,
              predictedClass: predictedClass,
              count: count,
            ),
          ),
        );
        // }

        // Now you can set profilepic to null
        // profilepic = null;
        // setState(() {
        //   _progress = 0.0;
        // });
      } else {
        // Handle the case where "def" document does not exist
        print("Document 'def' does not exist");
      }
      profilepic = null;
      print("User Created");
    } else {
      print("User not created");
    }
  }

  //for getting an image
  void getImage(ImageSource source) async {
    // File image = await ImagePicker.pickImage(source: source);
    XFile? image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      File? croppedImage = await ImageCropper().cropImage(
          sourcePath: image!.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxHeight: 224,
          maxWidth: 224,
          androidUiSettings: AndroidUiSettings(
              toolbarColor: Color(0xFF74546A),
              toolbarTitle: "Crop Image",
              statusBarColor: Color(0xFFFFEAEE),
              backgroundColor: Color(0xFFFFEAEE)));

      if (croppedImage != null) {
        setState(() {
          profilepic = croppedImage;
          _runInference(croppedImage);
        });
        // _runInference(croppedImage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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

    // int _currentIndex = 1;
    int currentIndex = 1;
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
          Navigator.pushReplacement(
              // Navigate to doc page
              // Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => DoctorListPage(
                        uid: widget.uid,
                      )));
          break;
      }
    }

    bool isDarkMode = false;
    void darkMode() {
      setState(() {
        isDarkMode = !isDarkMode;
      });
    }

    // ThemeData darkTheme = ThemeData(
    //   brightness: Brightness.dark,
    //   primaryColor: Colors.black, // Adjust primary color for dark theme
    //   hintColor: Colors.blueGrey, // Adjust accent color for dark theme
    //   scaffoldBackgroundColor: Colors.black26, // Adjust background color
    //   textTheme: TextTheme(
    //     bodyLarge: TextStyle(color: Colors.white), // Text color for dark theme
    //   ),
    // );
    // ThemeData lightTheme = ThemeData(
    //   brightness: Brightness.light,
    //   primaryColor: Colors.blue, // Adjust primary color for light theme
    //   hintColor: Colors.pink, // Adjust accent color for light theme
    //   scaffoldBackgroundColor: Colors.white, // Adjust background color
    //   textTheme: TextTheme(
    //     bodyLarge: TextStyle(color: Colors.black), // Text color for light theme
    //   ),
    // );

    // ThemeData getTheme() {
    //   return isDarkMode ? darkTheme : lightTheme;
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text("SkinAid"),
        backgroundColor: Color(0xFFFFEAEE),
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
        leading: Container(
          margin: EdgeInsets.all(4), // Adjust the margin as needed
          child: Image.asset(
            'images/logo.png', // Replace with the correct image path
            width: 50, // Adjust the width as needed
            height: 50, // Adjust the height as needed
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CupertinoButton(
                onPressed: () async {},
                child: (profilepic == null)
                    ? AvatarGlow(
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: Color.fromARGB(255, 236, 230, 231),
                          backgroundImage: AssetImage('images/Camera.png'),
                        ),
                        duration: Duration(seconds: 2),
                        glowCount: 2,
                        glowShape: BoxShape.circle,
                        glowColor: Color.fromARGB(100, 227, 226, 226),
                      )
                    : CircleAvatar(
                        radius: 100,
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        backgroundImage: FileImage(profilepic!),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  // padding: const EdgeInsets.all(16.0),
                  mainAxisAlignment: MainAxisAlignment
                      .spaceEvenly, // Space Evenly buttons horizontally

                  children: [
                    ElevatedButton.icon(
                      onPressed: () => {
                        getImage(ImageSource.camera),
                      },
                      icon: Icon(Icons.camera_alt_outlined),
                      label: Text('Camera'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Color(0xFF74546A),
                        backgroundColor: Color(0xFFFFEAEE),
                      ),
                    ),
                    SizedBox(width: 10.0), // Add spacing between buttons
                    ElevatedButton.icon(
                      onPressed: () => {
                        getImage(ImageSource.gallery),
                      },
                      icon: Icon(Icons.photo_library_outlined),
                      label: Text('Gallery'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Color(0xFF74546A),
                        backgroundColor: Color(0xFFFFEAEE),
                      ),
                    ),
                  ],
                ),
              ),
              LinearPercentIndicator(
                // value: _progress / 100 - 1,
                percent: _progress / 100,
                lineHeight: 20,
                animation: true,
                animationDuration: 1000,
                backgroundColor: Color.fromARGB(255, 234, 230, 231),
                // valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                progressColor: Color.fromARGB(255, 29, 23, 27),
              ),
              SizedBox(height: 8),
              Text('${_progress.toInt()}%',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  submitData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color(0xFF74546A), // Change button color here
                  // Add more styling properties as needed
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Color(0xFFFFEAEE), // Change text color here
                    fontSize:
                        16, // Change text font size here // Change text font weight here
                  ),
                ),
              )
            ],
          ),
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
}
