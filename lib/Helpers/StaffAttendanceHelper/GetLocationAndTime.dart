import 'dart:convert';

import 'package:digivity_admin_app/helpers/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getLocationAndTime(
  double apiRadius,
  double apiLatitude,
  double apiLongitude,
    BuildContext context
) async {
  try {
    bool hasPermission =
        await PermissionService.requestDeviceLocationPermission(context);
    if (!hasPermission) {
      print("Location permission not granted.");
      return {
        'latitude': 0.0,
        'longitude': 0.0,
        'distance': double.infinity,
        'isInside': false,
      };
    }

    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return {
        'latitude': 0.0,
        'longitude': 0.0,
        'distance': double.infinity,
        'isInside': false,
      };
    }

    // Get current mobile position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Calculate distance between API location and current location
    double distanceInMeters = Geolocator.distanceBetween(
      apiLatitude,
      apiLongitude,
      position.latitude,
      position.longitude,
    );

    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'distance': distanceInMeters,
      'isInside': distanceInMeters <= (apiRadius != 0 ? apiRadius : 150),
    };
  } catch (e) {
    print("Bug occurred during getting location: $e");
    return {
      'latitude': 0.0,
      'longitude': 0.0,
      'distance': double.infinity,
      'isInside': false,
    };
  }
}

/// Get Current Latitude And Longitude
Future<Map<String, dynamic>?> getCurrentPositionWithPlace(context) async {
  try {
    // Pehle permission check karo
    bool hasPermission =
        await PermissionService.requestDeviceLocationPermission(context);
    if (!hasPermission) {
      debugPrint("Location permission not granted.");
      return null;
    }

    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint("Location services are disabled.");
      return null;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Reverse geocoding using OpenStreetMap
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}",
    );
    final response = await http.get(url);

    String? placeName;
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      placeName = data['display_name'];
    }

    return {
      "latitude": position.latitude,
      "longitude": position.longitude,
      "place": placeName ?? "Unknown location",
    };
  } catch (e) {
    debugPrint("Error getting location: $e");
    return null;
  }
}
