import 'package:flutter/material.dart';

class DoctorInfo {
  final String name;
  final String imagePath;
  final String speciality;
  final String location;
  final int yearsOfExperience;
  final String clinicContactPhone;
  final String clinicContactEmail;
  final double rating;

  DoctorInfo({
    required this.name,
    required this.imagePath,
    required this.speciality,
    required this.location,
    required this.yearsOfExperience,
    required this.clinicContactPhone,
    required this.clinicContactEmail,
    required this.rating,
  });

  factory DoctorInfo.fromMap(Map<String, dynamic> map) {
    return DoctorInfo(
      name: map['name'] ?? '',
      imagePath: map['imagePath'] ??
          'images/doctor1.png', // Replace with your Firebase field name
      speciality: map['speciality'] ?? '',
      location: map['location'] ?? '',
      yearsOfExperience: map['yearsOfExperience'] ?? 0,
      clinicContactPhone: map['clinicContactPhone'] ?? '',
      clinicContactEmail: map['clinicContactEmail'] ?? '',
      rating: map.containsKey('rating') && map['rating'] is num
          ? (map['rating'] as num).toDouble()
          : 0.0,

      // rating: 0.0,
    );
  }
}

class DoctorCard extends StatelessWidget {
  final DoctorInfo doctor;

  DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                bottomLeft: Radius.circular(16.0),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 8.0), // Adjust the left padding as needed
              child: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(doctor.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    doctor.speciality,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                      ), // Icon for location
                      SizedBox(
                          width: 10), // Add some space between icon and text
                      Text(doctor.location),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.medical_services,
                      ), // Icon for years of experience
                      SizedBox(
                          width: 10), // Add some space between icon and text
                      Text('${doctor.yearsOfExperience} years'),
                    ],
                  ),
                  // SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.star),
                      SizedBox(width: 10.0),
                      Text('${doctor.rating}'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.phone),
                      SizedBox(width: 10.0),
                      Text(doctor.clinicContactPhone),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.email),
                      SizedBox(width: 8.0),
                      Text(doctor.clinicContactEmail),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
