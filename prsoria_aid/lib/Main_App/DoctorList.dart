import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skin_aid/Login/Login_page.dart';
import 'package:skin_aid/Main_App/AboutUs.dart';
import 'package:skin_aid/Main_App/Home_page.dart';
import 'package:skin_aid/Main_App/Info_page.dart';
import 'package:skin_aid/Main_App/Profile_Page.dart';
import 'package:skin_aid/Main_App/chatbotApp.dart';
import 'package:skin_aid/Main_App/components/DoctorCard.dart';
import 'package:skin_aid/Main_App/components/LocationFetcher.dart';

class DoctorListPage extends StatefulWidget {
  final String uid;
  DoctorListPage({required this.uid});

  @override
  _DoctorListPageState createState() => _DoctorListPageState();
}

bool filtered = false;

class _DoctorListPageState extends State<DoctorListPage> {
  // DoctorCard dc;
  List<DoctorInfo> doctors = [];
  List<DoctorInfo> storedDoctors = [];
  Set<String> locationSet = Set();
  bool _isExpanded = false;
  String? currentLocation = "";
  double yearsOfExperience = 1.0;
  double rating = 1.0;
  String selectedLocation = 'Select City';
  String selectedSpecialty = 'Select Disease';

  Future<List<DoctorInfo>> fetchDoctorsFromFirebase() async {
    List<DoctorInfo> doctors = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('doctors').get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        locationSet.add(data['location']);
        doctors.add(DoctorInfo.fromMap(data));
      }
    } catch (e) {
      print('Error fetching doctors: $e');
    }
    print(doctors);
    return doctors;
  }

  void filterByCurrentLocation() {
    List<DoctorInfo> filteredDoctors = storedDoctors;
    if (currentLocation != null) {
      filteredDoctors = filteredDoctors
          .where((doctor) => doctor.location == "Jaipur")
          .toList();
    }
    print(filteredDoctors);

    setState(() {
      doctors = filteredDoctors;
      filtered = true;
    });
  }

  void applyFilters() {
    // Filter doctors based on selected values
    List<DoctorInfo> filteredDoctors = storedDoctors;
    print("Filtered Doc");
    print(filteredDoctors);

    // Apply rating filter
    if (rating != 1.0) {
      filteredDoctors =
          filteredDoctors.where((doctor) => doctor.rating >= rating).toList();
    }

    // Apply years of experience filter
    if (yearsOfExperience != 1.0) {
      filteredDoctors = filteredDoctors
          .where((doctor) => doctor.yearsOfExperience >= yearsOfExperience)
          .toList();
    }

    // Apply location filter
    if (selectedLocation != 'Select City') {
      filteredDoctors = filteredDoctors
          .where((doctor) => doctor.location == selectedLocation)
          .toList();
    }

    // Apply specialty filter
    if (selectedSpecialty != 'Select Disease') {
      filteredDoctors = filteredDoctors
          .where((doctor) => doctor.speciality == selectedSpecialty)
          .toList();
    }
    setState(() {
      doctors = filteredDoctors;
      filtered = true;
    });
    // DoctorListView()
    // DoctorListView(doctors: filteredDoctors);
    if (filteredDoctors.isEmpty) {
      Text("No Results Found");
    }
    // widget.updateDoctorsList(filteredDoctors);

    // Print filtered doctors
    print('Filtered Doctors:');
    print(filteredDoctors);
    // filteredDoctors.forEach((doctor) {
    //   print(doctor.name);
    // });
  }

  void clearFilters() {
    // Clear filters here
    setState(() {
      filtered = false;
      doctors = storedDoctors;
      rating = 1.0;
      yearsOfExperience = 1.0;
      selectedLocation = 'Select City';
      selectedSpecialty = 'Select Disease';
    });
  }

  var searchText = "";

  @override
  void initState() {
    super.initState();
    // Call fetchDoctorsFromFirebase and update the state when data is fetched
    fetchDoctorsFromFirebase().then((fetchedDoctors) {
      setState(() {
        doctors = fetchedDoctors;
        storedDoctors = fetchedDoctors;
      });
    });
    locationSet.add("Select City");
  }

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 3;
    int currentIndex = 3;
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
          // Navigator.pushReplacement(
          //     // Navigate to doc page
          //     // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => SkinCare(
          //               uid: widget.uid,
          //             )));
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Doctor's List"),
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

        // actions: [
        //   PopupMenuButton<String>(
        //     icon: Icon(
        //       Icons.menu,
        //       color: Color.fromARGB(
        //           255, 132, 101, 122), // Change the color of the icon here
        //     ),
        //     onSelected: (value) {
        //       switch (value) {
        //         case 'Filter':
        //           // Handle filter button press
        //           break;
        //       }
        //     },
        //     itemBuilder: (context) => [
        //       PopupMenuItem(
        //         value: 'Filter',
        //         child: Text('Filter'),
        //       ),
        //     ],
        //   ),
        //],
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Doctors...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: Icon(Icons.search), // Optional search icon
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                  // Filter doctors based on search text
                  if (searchText.isEmpty) {
                    // If searchText is empty, display all doctors
                    doctors = storedDoctors;
                  } else {
                    doctors = storedDoctors
                        .where((doctor) =>
                            doctor.name.toLowerCase().contains(searchText) ||
                            doctor.speciality
                                .toLowerCase()
                                .contains(searchText) ||
                            doctor.location.toLowerCase().contains(searchText))
                        .toList();
                  }
                });
              },
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter icon
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_list,
                          color: filtered ? Color(0xFF74546A) : Colors.black,
                          size: 25.0,
                        ),
                        SizedBox(width: 8),
                        Text('Filter'),
                      ],
                    ),
                  ),
                  // Expandable section
                  if (_isExpanded) ...[
                    Text("Rating:"),
                    // Rating slider
                    Slider(
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: 'Rating',
                      activeColor: Color(0xFF74546A),
                      onChanged: (double value) {
                        setState(() {
                          rating = value;
                        });
                      },
                      value: rating,
                    ),
                    Text("Years of Experience"),
                    // Years of experience slider
                    Slider(
                      min: 1,
                      max: 30,
                      divisions: 29,
                      label: 'Years of Experience',
                      activeColor: Color(0xFF74546A),
                      onChanged: (double value) {
                        setState(() {
                          yearsOfExperience = value;
                        });
                      },
                      value: yearsOfExperience,
                    ),
                    // Location dropdown
                    DropdownButtonFormField<String>(
                      value: selectedLocation,
                      onChanged: (value) {
                        setState(() {
                          selectedLocation = value!;
                        });
                      },
                      items: locationSet
                          .map((location) => DropdownMenuItem(
                                value: location,
                                child: Text(location),
                              ))
                          .toList(),
                      decoration: InputDecoration(labelText: 'Location'),
                    ),

                    // Specialty dropdown
                    DropdownButtonFormField<String>(
                      value: selectedSpecialty,
                      onChanged: (value) {
                        setState(() {
                          selectedSpecialty = value!;
                        });
                      },
                      items:
                          ['Select Disease', 'Psoriasis', 'Exzema', 'Scabies']
                              .map((specialty) => DropdownMenuItem(
                                    value: specialty,
                                    child: Text(specialty),
                                  ))
                              .toList(),
                      decoration: InputDecoration(labelText: 'Specialty'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Color(0xFF74546A),
                                ),
                                foregroundColor: MaterialStateColor.resolveWith(
                                  (states) => Color(0xFFFFEAEE),
                                )),
                            onPressed: () async {
                              String? cityName = await getCityName(context);
                              if (cityName != null) {
                                // Handle the city name, such as displaying it or using it in further operations
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('City Name: $cityName'),
                                  ),
                                );
                                filterByCurrentLocation();
                              } else {
                                // Handle case when city name is null (e.g., error occurred or permission denied)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to get city name.'),
                                  ),
                                );
                              }
                            },
                            icon: Icon(Icons.location_on),
                            label: Text('Filter by Current Location'),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: applyFilters,
                              child: Text('Apply Filters'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Color(0xFF74546A),
                                ),
                                foregroundColor: MaterialStateColor.resolveWith(
                                  (states) => Color(0xFFFFEAEE),
                                ),
                              ),
                            ),
                            // Clear filters button
                            ElevatedButton(
                              onPressed: clearFilters,
                              child: Text('Clear Filters'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Color(0xFF74546A),
                                ),
                                foregroundColor: MaterialStateColor.resolveWith(
                                  (states) => Color(0xFFFFEAEE),
                                ),
                              ),
                            ),
                          ]),
                    ),
                    // Apply filters button
                  ],
                ],
              ),
            ),

            if (doctors.isEmpty) Text('No Results Found'),

            DoctorListView(doctors: doctors),
          ],
        ),
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

class DoctorListView extends StatelessWidget {
  final List<DoctorInfo> doctors;

  DoctorListView({required this.doctors});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        return DoctorCard(doctor: doctors[index]);
      },
    );
  }
}
