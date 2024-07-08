import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorInfo {
  final String name;
  // final String imagePath;
  final String speciality;
  final String location;
  final int yearsOfExperience;
  final String clinicContactPhone;
  final String clinicContactEmail;
  final double rating;

  DoctorInfo({
    required this.name,
    // required this.imagePath,
    required this.speciality,
    required this.location,
    required this.yearsOfExperience,
    required this.clinicContactPhone,
    required this.clinicContactEmail,
    required this.rating,
  });
}

List<DoctorInfo> doctors = [
  DoctorInfo(
    name: 'Dr. Rahul Verma',
    speciality: 'Scabies',
    location: 'Mountain View',
    yearsOfExperience: 10,
    clinicContactPhone: '(91) 2345 6789',
    clinicContactEmail: 'rahul.verma@clinic.com',
    rating: 3.2,
  ),
  DoctorInfo(
    name: 'Dr. Sneha Singh',
    speciality: 'Psoriasis',
    location: 'Delhi',
    yearsOfExperience: 8,
    clinicContactPhone: '(91) 8765 4321',
    clinicContactEmail: 'sneha.singh@clinic.com',
    rating: 4.1,
  ),
  DoctorInfo(
    name: 'Dr. Mohan Patel',
    speciality: 'Exzema',
    location: 'Mumbai',
    yearsOfExperience: 15,
    clinicContactPhone: '(91) 5678 1234',
    clinicContactEmail: 'mohan.patel@clinic.com',
    rating: 2.9,
  ),
  // Add more doctor information objects here
  DoctorInfo(
    name: 'Dr. Tanvi Sharma',
    speciality: 'Scabies',
    location: 'Pune',
    yearsOfExperience: 12,
    clinicContactPhone: '(91) 3456 7890',
    clinicContactEmail: 'tanvi.sharma@clinic.com',
    rating: 3.8,
  ),
  DoctorInfo(
    name: 'Dr. Arjun Mehta',
    speciality: 'Psoriasis',
    location: 'Jaipur',
    yearsOfExperience: 18,
    clinicContactPhone: '(91) 6543 2109',
    clinicContactEmail: 'arjun.mehta@clinic.com',
    rating: 4.3,
  ),
  DoctorInfo(
    name: 'Dr. Pooja Gupta',
    speciality: 'Exzema',
    location: 'Nagpur',
    yearsOfExperience: 22,
    clinicContactPhone: '(91) 4321 0987',
    clinicContactEmail: 'pooja.gupta@clinic.com',
    rating: 2.5,
  ),
  DoctorInfo(
    name: 'Dr. Varun Singh',
    speciality: 'Scabies',
    location: 'Chennai',
    yearsOfExperience: 7,
    clinicContactPhone: '(91) 7890 2345',
    clinicContactEmail: 'varun.singh@clinic.com',
    rating: 4.0,
  ),
  // Repeat entries to reach 50
  DoctorInfo(
    name: 'Dr. Priya Sharma',
    speciality: 'Scabies',
    location: 'Mountain View',
    yearsOfExperience: 12,
    clinicContactPhone: '(91) 1234 5678',
    clinicContactEmail: 'priya.sharma@clinic.com',
    rating: 3.7,
  ),
  DoctorInfo(
    name: 'Dr. Rajesh Singh',
    speciality: 'Psoriasis',
    location: 'Delhi',
    yearsOfExperience: 18,
    clinicContactPhone: '(91) 9876 5432',
    clinicContactEmail: 'rajesh.singh@clinic.com',
    rating: 2.8,
  ),
  DoctorInfo(
    name: 'Dr. Neha Gupta',
    speciality: 'Exzema',
    location: 'Mumbai',
    yearsOfExperience: 14,
    clinicContactPhone: '(91) 6789 1234',
    clinicContactEmail: 'neha.gupta@clinic.com',
    rating: 4.5,
  ),
  // Repeat entries to reach 50
  DoctorInfo(
    name: 'Dr. Rahul Verma',
    speciality: 'Scabies',
    location: 'Mountain View',
    yearsOfExperience: 10,
    clinicContactPhone: '(91) 2345 6789',
    clinicContactEmail: 'rahul.verma@clinic.com',
    rating: 2.6,
  ),
  DoctorInfo(
    name: 'Dr. Sneha Singh',
    speciality: 'Psoriasis',
    location: 'Delhi',
    yearsOfExperience: 8,
    clinicContactPhone: '(91) 8765 4321',
    clinicContactEmail: 'sneha.singh@clinic.com',
    rating: 4.2,
  ),
  DoctorInfo(
    name: 'Dr. Mohan Patel',
    speciality: 'Exzema',
    location: 'Mumbai',
    yearsOfExperience: 15,
    clinicContactPhone: '(91) 5678 1234',
    clinicContactEmail: 'mohan.patel@clinic.com',
    rating: 3.1,
  ),
  // Add more repeated entries until you reach 50
];

void addDoctorsToFirebase(List<DoctorInfo> doctors) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    for (var doctor in doctors) {
      await firestore.collection('doctors').add({
        'name': doctor.name,
        'speciality': doctor.speciality,
        'location': doctor.location,
        'yearsOfExperience': doctor.yearsOfExperience,
        'clinicContactPhone': doctor.clinicContactPhone,
        'clinicContactEmail': doctor.clinicContactEmail,
        'rating': doctor.rating,
      });
    }

    print('Doctors added to Firestore successfully!');
  } catch (e) {
    print('Error adding doctors to Firestore: $e');
  }
}
