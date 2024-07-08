import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

const apiKey =
    'da22a2bf3e2f185dd20dcef55b8ec425'; // Replace with your actual API key

String buildWeatherUrl(String cityName, {double? lat, double? lon}) {
  const baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  if (cityName.isNotEmpty) {
    // Use cityName here
    return '$baseUrl?q=$cityName&appid=$apiKey';
  } else if (lat != null && lon != null) {
    return '$baseUrl?lat=$lat&lon=$lon&appid=$apiKey';
  } else {
    throw Exception('Either city name or coordinates are required.');
  }
}

Future<Map<String, dynamic>> fetchWeatherData(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return json.decode(response.body) as Map<String, dynamic>;
  } else {
    throw Exception('Failed to fetch weather data');
  }
}

Future<String?> getCityName(BuildContext context) async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled. Request user to enable them.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location services are disabled.'),
        ),
      );
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permanently denied permissions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location permissions are denied forever.'),
          ),
        );
        return null;
      }
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    final url = buildWeatherUrl("",
        lat: position.latitude, lon: position.longitude); // Use cityName here
    final data = await fetchWeatherData(url);
    final cityName = data['name'] as String;
    print(cityName);
    return cityName;
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to get location: $e'),
      ),
    );
    return null;
  }
}
