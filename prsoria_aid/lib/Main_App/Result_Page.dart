import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skin_aid/Main_App/DoctorList.dart';
import 'package:skin_aid/Main_App/Home_page.dart';
import 'package:skin_aid/Main_App/Info_page.dart';
import 'package:skin_aid/Main_App/Profile_Page.dart';
import 'package:skin_aid/Main_App/chatbotApp.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:math' as math;

class ResultPage extends StatefulWidget {
  final String uid;
  String? image;
  int predictedClass;
  double modelConfidenceScore;
  int count;
  ResultPage(
      {required this.uid,
      required this.image,
      required this.predictedClass,
      required this.modelConfidenceScore,
      required this.count});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  // int _currentIndex = 1;
  // Define expansion states for each section
  bool isScabiesExpanded = false;
  bool isEczemaExpanded = false;
  bool isPsoriasisExpanded = false;
  // State for symptom selection
  bool isSymptomsExpanded = true; // Start with symptoms expanded
  bool showPotentialDiseases = false; // Initially hide potential diseases
  bool imageResultUpdated = false;
  bool buttonPressed = false;
  late String resultDisease;
  late double resultProbability;

  Map<String, Map<String, double>> symptomMatrix = {
    "Itching": {"Eczema": 0.8, "Psoriasis": 0.6, "Scabies": 0.9},
    "Redness": {
      "Eczema": 0.5,
      "Psoriasis": 0.6,
      "Scabies": 0.5
    }, // Reduced for normal skin
    "Rash": {
      "Eczema": 0.8,
      "Psoriasis": 0.8,
      "Scabies": 0.8
    }, // Slightly reduced for normal skin
    "Blisters": {"Eczema": 0.5, "Psoriasis": 0.2, "Scabies": 0.3},
    "Scaling": {"Eczema": 0.6, "Psoriasis": 0.9, "Scabies": 0.1},
    "Dryness": {
      "Eczema": 0.6,
      "Psoriasis": 0.5,
      "Scabies": 0.3
    }, // Reduced for normal skin
    "Inflammation": {"Eczema": 0.7, "Psoriasis": 0.8, "Scabies": 0.6},
    "Pain": {"Eczema": 0.3, "Psoriasis": 0.5, "Scabies": 0.7},
    "Pus": {"Eczema": 0.2, "Psoriasis": 0.3, "Scabies": 0.4},
    "Hair loss": {"Eczema": 0.05, "Psoriasis": 0.1, "Scabies": 0.1},
    "Nail changes": {"Eczema": 0.1, "Psoriasis": 0.8, "Scabies": 0.1},
    "No Symptoms": {"Eczema": 0.0, "Psoriasis": 0.0, "Scabies": 0.0},
  };
  List<String> selectedSymptoms = [];
  List<String> allSymptoms = [
    'Itching',
    'Redness',
    'Rash',
    'Blisters',
    'Scaling',
    'Dryness',
    'Inflammation',
    'Pain',
    'Pus',
    'Hair loss',
    'Nail changes',
    'No Symptoms'
  ];

  int _currentIndex = 1;
  Map<String, double> diseaseProbabilities = {};

  String getMostProbableDisease() {
    if (selectedSymptoms.isEmpty) {
      return '';
    }

    for (String disease in symptomMatrix[selectedSymptoms[0]]!.keys) {
      double avgProbability = 0.0;
      for (String symptom in selectedSymptoms) {
        avgProbability += symptomMatrix[symptom]![disease]!;
      }
      avgProbability /= selectedSymptoms.length;
      diseaseProbabilities[disease] = avgProbability;
    }

    String mostProbableDisease = '';
    double? maxProbability = 0.0;
    for (String disease in diseaseProbabilities.keys) {
      if (diseaseProbabilities[disease]! > maxProbability!) {
        maxProbability = diseaseProbabilities[disease];
        mostProbableDisease = disease;
      }
    }
    // print(mostProbableDisease);
    return mostProbableDisease;
  }

  String getSkinConditionName(int predictedClass) {
    switch (predictedClass) {
      case 0:
        return 'Psoriasis';
      case 1:
        return 'Eczema';
      case 2:
        return 'Normal Skin';
      case 3:
        return 'Scabies';
      default:
        return 'Unknown'; // Return 'Unknown' if the predictedClass doesn't match any known condition.
    }
  }

  void submitData() async {
    String uid = widget.uid;
    print(uid);
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection(uid).doc("def").get();

    // Check if the document exists
    if (snapshot.exists) {
      if (imageResultUpdated == false && buttonPressed == true) {
        String diseaseCount = resultDisease.toLowerCase() + "Count";
//<<<<<<< ForgotPassword
        if (resultDisease == "Normal Skin") {
          diseaseCount = "normalSkinCount";
        }
//=======
//>>>>>>> main
        int diseaseCounter =
            (snapshot.data() as Map<String, dynamic>?)?[diseaseCount] ?? 0;
        diseaseCounter++;
        // Update the "def" document with the new count
        await FirebaseFirestore.instance
            .collection(uid)
            .doc(widget.count.toString())
            .update({
          'result': resultDisease,
          'probability': resultProbability * 100,
        });

        await FirebaseFirestore.instance
            .collection(uid)
            .doc("def")
            .update({diseaseCount: diseaseCounter});
        print("Doc Updated");
        imageResultUpdated = true;
        buttonPressed = false;
      } else {
        print("Nothing new to update");
      }
    } else {
      // Handle the case where "def" document does not exist
      print("Document 'def' does not exist");
    }
  }

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

  Widget _buildPotentialDiseases() {
    String mostProbableDisease = getMostProbableDisease();
    print("Symptoms Prediction : $mostProbableDisease");
    if (mostProbableDisease.isNotEmpty) {
      String findDisease = getSkinConditionName(widget.predictedClass);
      print("Model disease: $findDisease");
      double probability;
      if (mostProbableDisease == findDisease &&
          widget.modelConfidenceScore > 0.8) {
        resultDisease = findDisease;
        probability = widget.modelConfidenceScore;
      } else {
        resultDisease = findDisease;
        probability = diseaseProbabilities[findDisease] ?? 0.0;
        probability = widget.modelConfidenceScore + 0.2 * probability;
      }
      // probability = diseaseProbabilities[findDisease] ?? 0.0;
      // probability = 0.8 * widget.modelConfidenceScore + 0.2 * probability;
      resultDisease = findDisease;
      resultProbability = probability;
      submitData();
      return Text(
        '$resultDisease (${(probability * 100).toStringAsFixed(2)}%)',
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      );
    } else {
      return Text('No potential diseases found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result Page'),
        backgroundColor: Color.fromARGB(255, 239, 230, 232),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display image
            if (widget.image != null) ...[
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  child: Image.network(
                    widget.image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 24.0),
            ] else ...[
              Center(
                child: Text(
                  'NO image',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 24.0),
            ],
            // Symptom Selection Section
            _buildSymptomSelection(),
            // Display selected symptoms and potential diseases
            if (selectedSymptoms.isNotEmpty) ...[
              SizedBox(height: 24.0),
              Text(
                'Selected Symptoms:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                children: selectedSymptoms
                    .map((symptom) => Chip(label: Text(symptom)))
                    .toList(),
              ),
              SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showPotentialDiseases = true;
                      buttonPressed = true;
                    });
                  },
                  child: Text(
                    'Potential Diseases :-',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color(0xFFFFEAEE),
                    backgroundColor: Color(0xFF74546A), // Set text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Optional border radius
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              if (showPotentialDiseases) ...[
                Container(
                  // padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    // color: Colors.lightBlueAccent, // Set background color here
                    borderRadius:
                        BorderRadius.circular(10.0), // Optional border radius
                  ),
                  child: Text(
                    'Potential Disease :',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      // color: Color(0xFFFFEAEE),
                      // backgroundColor: Color(0xFF74546A), // Set text color here
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                _buildPotentialDiseases(),
                SizedBox(height: 16.0),
                Text(
                  'Disclaimer: This is for informational purposes only and should not be considered a diagnosis. Similar symptoms may be related to other diseases. Please consult a healthcare professional for accurate diagnosis and treatment.',
                  style: TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic),
                ),
              ] else ...[
                Text(
                  'Select symptoms to know potential diseases',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ],
            SizedBox(height: 24.0),
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

  Widget _buildSymptomSelection() {
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
            onTap: () {
              setState(() {
                isSymptomsExpanded = !isSymptomsExpanded;
              });
            },
            child: Row(
              children: [
                Text(
                  'Select Symptoms (Max 5)',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                    isSymptomsExpanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          if (isSymptomsExpanded)
            Wrap(
              spacing: 8.0,
              children: allSymptoms.map((symptom) {
                bool isSelected = selectedSymptoms.contains(symptom);
                return FilterChip(
                  label: Text(symptom),
                  selected: isSelected,
                  onSelected: (value) {
                    setState(() {
                      if (value) {
                        if (selectedSymptoms.length < 5) {
                          selectedSymptoms.add(symptom);
                          imageResultUpdated = false;
                        } else {
                          // Show a snackbar or alert if trying to select more than 5
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('You can select up to 5 symptoms.'),
                            ),
                          );
                        }
                      } else {
                        selectedSymptoms.remove(symptom);
                        imageResultUpdated = false;
                      }
                    });
                  },
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
