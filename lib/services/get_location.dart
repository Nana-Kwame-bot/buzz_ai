import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

Future<Map<String, dynamic>> getLocation() async {
  LocationPermission permission;

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error("Location services are disabled!");
    }
  }

  Position position = await Geolocator.getCurrentPosition();
  List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

  Placemark placemark = placemarks.first;

  return {
    "position": position,
    "placemark": placemark,
  };
}
