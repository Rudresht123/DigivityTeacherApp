import 'package:geolocator/geolocator.dart';

Future<Map<String, dynamic>> getLocationAndTime(double apiraduis,double apilatitude, double apilongitude) async {
  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    // Calculate distance
    double distanceInMeters = Geolocator.distanceBetween(
      apilatitude,
      apilongitude,
      position.latitude,
      position.longitude,
    );

    print(distanceInMeters);
    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'distance': distanceInMeters,
      'isInside': distanceInMeters <= apiraduis ?? 150,
    };
  } catch (e) {
    print("Bug Occured During The Get Giolocator $e");
    return {
      'latitude': 0.0,
      'longitude': 0.0,
      'distance': double.infinity,
      'isInside': false,
    };
  }
}
