import 'package:avatar_glow/avatar_glow.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skin_aid/Main_App/Home_page.dart';
import 'package:skin_aid/Main_App/Info_page.dart';
import 'package:skin_aid/Main_App/chatbotApp.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  ProfilePage({required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // int _currentIndex = 1;
  int psoriasisCount = 0;
  int scabiesCount = 0;
  int eczemaCount = 0;
  int normalSkinCount = 0;
  @override
  void initState() {
    super.initState();
    print("Innitstate");
    _fetchData();
  }

  Future<void> _fetchData() async {
    print("reached _fetchdata");

    final docRef = FirebaseFirestore.instance.collection(widget.uid).doc("def");
    print("reached _fetchdata");

    final docSnapshot = await docRef.get();
    print("reached _fetchdata");

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null) {
        setState(() {
          psoriasisCount =
              data['psoriasisCount'] ?? 0; // Handle potential null value
          scabiesCount = data['scabiesCount'] ?? 0;
          eczemaCount = data['eczemaCount'] ?? 0;
          normalSkinCount = data['normalSkinCount'] ?? 0;
          print(psoriasisCount);
        });
      }
    }
  }

  void deleteData(String? documentId) async {
    await FirebaseFirestore.instance
        .collection(widget.uid)
        .doc(documentId)
        .delete();
    print("User Deleted");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        backgroundColor: Color(0xFFFFEAEE),
        automaticallyImplyLeading: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 24.0),
              Container(
                width: 360, // Set the desired width for the card
                child: Card(
                  elevation: 10,
                  color: Color(
                      0xFF74546A), // Add some elevation for a shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15), // Add rounded corners
                    side: BorderSide(
                      width: 1, // Adjust border width as needed
                      color: Colors.grey[300]!, // Add border color
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Center the content vertically
                        children: [
                          Text(
                            "User Information",
                            style: TextStyle(
                              fontSize: 30.0, // Adjust font size as needed
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(
                                  255, 246, 236, 238), // Add text color
                            ),
                          ),
                          SizedBox(height: 5), // Add some vertical spacing
                          Text(
                            "Your personal details",
                            textAlign: TextAlign
                                .center, // Center the text horizontally
                            style: TextStyle(
                              fontSize: 15.0, // Adjust font size as needed
                              color: Color.fromARGB(255, 250, 238,
                                  241), // Add secondary text color
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection(widget.uid)
                    .doc("def")
                    .get(),
                builder: (context, snapshot) {
                  print(TimeOfDay.now().toString());

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return Center(child: Text('No user found for this UID'));
                  }

                  // Access the user data
                  Map<String, dynamic>? userData =
                      snapshot.data!.data() as Map<String, dynamic>?;

                  if (userData == null) {
                    return Center(child: Text('User data is null'));
                  }
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Main card occupying full width
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Align text to left
                              children: [
                                Icon(Icons.person), // Icon for name
                                SizedBox(
                                    width:
                                        8.0), // Spacing between icon and text
                                Flexible(
                                  child: Text('Name: ${userData['name']}'),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Information cards (ensure two per row, wrap to next row)
                        Wrap(
                          spacing: 8.0, // Spacing between cards
                          runSpacing: 8.0, // Spacing between rows of cards
                          children: [
                            // Card for Blood Group (ensure it's displayed)
                            Row(
                              mainAxisSize:
                                  MainAxisSize.min, // Fix the width of the row
                              children: [
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons
                                            .bloodtype), // Icon for blood group
                                        SizedBox(width: 8.0),
                                        Text(
                                            'BLOOD GROUP: ${userData['bloodGroup'] ?? 'NA'}'), // Display 'NA' if bloodGroup is missing
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.0), // Spacing between cards
                              ],
                            ),
                            // Iterate through remaining entries (excluding name and blood group)
                            for (var entry in userData.entries.where((entry) =>
                                entry.key != 'name' &&
                                entry.key != 'bloodGroup'))
                              Row(
                                mainAxisSize: MainAxisSize
                                    .min, // Fix the width of the row
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, // Justify content
                                children: [
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            // Choose icon based on entry key
                                            entry.key == 'gender'
                                                ? Icons.wc
                                                : entry.key == 'age'
                                                    ? Icons.calendar_today
                                                    : entry.key == 'birthDate'
                                                        ? Icons.cake
                                                        : entry.key == 'city'
                                                            ? Icons
                                                                .location_city
                                                            : entry.key ==
                                                                    'DateCreated'
                                                                ? Icons
                                                                    .calendar_view_day
                                                                : Icons
                                                                    .info, // Default icon
                                          ),
                                          SizedBox(width: 8.0),
                                          Text(
                                              '${entry.key.toUpperCase()}: ${entry.value}'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.0), // Spacing between cards
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              // Card for analysis
              Container(
                width: 360, // Set the desired width for the card
                child: Card(
                  elevation: 10,
                  color: Color(
                      0xFF74546A), // Add some elevation for a shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15), // Add rounded corners
                    side: BorderSide(
                      width: 1, // Adjust border width as needed
                      color: Colors.grey[300]!, // Add border color
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Center the content vertically
                        children: [
                          Text(
                            "OverAll Picture",
                            style: TextStyle(
                              fontSize: 30.0, // Adjust font size as needed
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(
                                  255, 246, 236, 238), // Add text color
                            ),
                          ),
                          SizedBox(height: 5), // Add some vertical spacing
                          Text(
                            "Grab all picture",
                            textAlign: TextAlign
                                .center, // Center the text horizontally
                            style: TextStyle(
                              fontSize: 15.0, // Adjust font size as needed
                              color:
                                  Color(0xFFFAEEF1), // Add secondary text color
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                width: 350,
                height: 350,
                padding: EdgeInsets.all(40),
                child: PieChart(
                    swapAnimationCurve: Curves.easeIn,
                    swapAnimationDuration: const Duration(milliseconds: 750),
                    PieChartData(sections: [
                      PieChartSectionData(
                        value: psoriasisCount
                            .toDouble(), // Convert to double for chart
                        showTitle: true,
                        title: "Psoriasis",
                        color: Color.fromARGB(255, 228, 214, 217),
                        titlePositionPercentageOffset:
                            BorderSide.strokeAlignOutside,
                      ),
                      PieChartSectionData(
                        value: scabiesCount.toDouble(),
                        showTitle: true,
                        title: "Scabies",
                        titleStyle:
                            TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        color: Color.fromARGB(255, 75, 68, 72),
                        titlePositionPercentageOffset:
                            BorderSide.strokeAlignOutside,
                      ),
                      PieChartSectionData(
                        value: eczemaCount.toDouble(),
                        showTitle: true,
                        title: "Eczema",
                        color: Color.fromARGB(255, 89, 62, 80),
                        titlePositionPercentageOffset:
                            BorderSide.strokeAlignOutside,
                      ),
                      PieChartSectionData(
                        value: normalSkinCount.toDouble(),
                        showTitle: true,
                        title: "Normal Skin",
                        color: Color.fromARGB(255, 131, 94, 103),
                        titlePositionPercentageOffset:
                            BorderSide.strokeAlignOutside,
                      ),
                    ])),
              ),
              Container(
                width: 360, // Set the desired width for the card
                child: Card(
                  elevation: 10,
                  color: Color(
                      0xFF74546A), // Add some elevation for a shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15), // Add rounded corners
                    side: BorderSide(
                      width: 1, // Adjust border width as needed
                      color: Colors.grey[300]!, // Add border color
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Center the content vertically
                        children: [
                          Text(
                            "History",
                            style: TextStyle(
                              fontSize: 30.0, // Adjust font size as needed
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(
                                  255, 246, 236, 238), // Add text color
                            ),
                          ),
                          SizedBox(height: 5), // Add some vertical spacing
                          Text(
                            "See your past uploads",
                            textAlign: TextAlign
                                .center, // Center the text horizontally
                            style: TextStyle(
                              fontSize: 15.0, // Adjust font size as needed
                              color:
                                  Color(0xFFFAEEF1), // Add secondary text color
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(widget.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData && snapshot.data != null) {
                      final documents = snapshot.data!.docs;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          // Remove crossAxisSpacing and mainAxisSpacing for consecutive items
                        ),
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          final documentId = documents[index].id;
                          final user =
                              documents[index].data() as Map<String, dynamic>;

                          // Exclude the document named "def" from being displayed
                          if (documentId == "def") return Container();

                          return Center(
                            child: ImageTile(
                              user: user,
                              documentId: documentId,
                              deleteData: deleteData,
                            ),
                          );
                        },
                      );
                    } else {
                      return Text("NO DATA FOUND");
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: CurvedNavigationBar(
      //   backgroundColor: Color(0x00000000),
      //   color: Color(0xFF74546A),
      //   animationDuration: Duration(milliseconds: 300),
      //   // currentIndex: _currentIndex,
      //   index: _currentIndex,
      //   onTap: _onNavItemTapped,
      //   items: [
      //     // Icon(icon)
      //     Icon(
      //       Icons.info,
      //       color: Color(0xFFFFEAEE),
      //     ),
      //     Icon(
      //       Icons.camera,
      //       color: Color(0xFFFFEAEE),
      //     ),
      //     Icon(
      //       Icons.message_outlined,
      //       color: Color(0xFFFFEAEE),
      //     ),
      //     Icon(
      //       Icons.person,
      //       color: Color(0xFFFFEAEE),
      //     ),
      //   ],
      // ),
    );
  }
}

class ImageTile extends StatelessWidget {
  final Map<String, dynamic> user;
  final String? documentId;
  final void Function(String?) deleteData;

  const ImageTile({
    required this.user,
    required this.documentId,
    required this.deleteData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: <Widget>[
              Image.network(
                user["pic"] != null
                    ? user["pic"]
                    : "https://via.placeholder.com/200",
                fit: BoxFit.fitHeight,
                height: 200,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.white,
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onPressed: () {
                      deleteData(documentId);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
          child: Text(
            "Uploaded on: ${user["uploadDate"]}",
            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

void main() => runApp(MaterialApp(
      home: ProfilePage(uid: 'your_user_id_here'),
    ));
