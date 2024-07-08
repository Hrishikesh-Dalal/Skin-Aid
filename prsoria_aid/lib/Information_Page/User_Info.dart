import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:skin_aid/Main_App/Home_page.dart';
import 'package:flutter/cupertino.dart';

class UserProfileScreen extends StatefulWidget {
  final String uid;

  const UserProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController cityController;
  String selectedGender = '';
  String selectedBloodGroup = '';
  DateTime? selectedBirthDate;
  List<String> gender = ['Male', 'Female', 'Other'];
  List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    ageController = TextEditingController();
    cityController = TextEditingController();
    checkUserExists();
  }

  Future<void> checkUserExists() async {
    try {
      var user = await _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userSnapshot =
            await _firestore.collection('users').doc(widget.uid).get();
        if (userSnapshot.exists) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => UserProfileScreen(
                      uid: widget.uid,
                    )),
          );
        }
      }
    } catch (e) {
      print("Error checking user: $e");
    }
  }

  Future<void> saveUserInfo() async {
    try {
      if (selectedBloodGroup.isNotEmpty &&
          selectedGender.isNotEmpty &&
          selectedBirthDate != null) {
        await _firestore.collection(widget.uid).doc("def").set({
          'name': nameController.text,
          'gender': selectedGender,
          'age': calculateAge(selectedBirthDate!),
          'birthDate': DateFormat('dd-MM-yyyy').format(selectedBirthDate!),
          'bloodGroup': selectedBloodGroup,
          'city': cityController.text,
          'count': 0,
          'DateCreated': DateFormat('dd-MM-yyyy').format(DateTime.now()),
          'eczemaCount': 0,
          'psroiasisCount': 0,
          'scabiesCount': 0,
          'normalSkinCount': 0
        });
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Home(
                    uid: widget.uid,
                  )),
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content:
                Text('Please select a gender, blood group, and birth date.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              )
            ],
          ),
        );
      }
    } catch (e) {
      print("Error saving user info: $e");
    }
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFFFFEAEE), title: Text('User Profile')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 60),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: selectedGender.isNotEmpty ? selectedGender : null,
                hint: Text('Select Gender'),
                items: gender.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedBirthDate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null && picked != selectedBirthDate) {
                    setState(() {
                      selectedBirthDate = picked;
                      ageController.text = calculateAge(selectedBirthDate!)
                          .toString(); // Automatically fill age
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: TextEditingController(
                        text: selectedBirthDate != null
                            ? DateFormat('dd-MM-yyyy')
                                .format(selectedBirthDate!)
                            : ''),
                    decoration: InputDecoration(
                      labelText: 'Birth Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: ageController,
                enabled: false,
                decoration: InputDecoration(labelText: 'Age'),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value:
                    selectedBloodGroup.isNotEmpty ? selectedBloodGroup : null,
                hint: Text('Select Blood Group'),
                items: bloodGroups.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedBloodGroup = value!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: cityController,
                decoration: InputDecoration(labelText: 'City'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  saveUserInfo();
                },
                child: Text(
                  'Save',
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
                    EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Set border radius
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
