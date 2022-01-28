import 'dart:async';
import 'dart:developer';
import 'package:buzz_ai/models/address/address.dart';
import 'package:buzz_ai/models/home/coordinates/coordinates.dart';
import 'package:buzz_ai/services/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart' as webservice;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreenController extends ChangeNotifier {
  TextEditingController sourceTextController = TextEditingController();
  TextEditingController destinationTextController = TextEditingController();

  Coordinates coordinates = const Coordinates(
    sourceLatitude: 37.42796133580664,
    sourceLongitude: -122.085749655962,
    destinationLatitude: 0,
    destinationLongitude: 0,
  );

  Address address = const Address(
    street: '',
    subLocality: '',
    locality: '',
    postalCode: '',
    country: '',
  );
  final Completer<GoogleMapController> googleMapController = Completer();
  late GoogleMapController mapController;

  /// this [Map] will hold my [markers]
  final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  /// this [Map] will hold the generated [polylines]
  final Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};

  /// this will hold each [polyline] coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];

  /// this is the key object - the [PolylinePoints]
  /// which generates every [polyline] between start and finish
  PolylinePoints polylinePoints = PolylinePoints();

  CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  void _resetMap() {
    markers.clear();
    polylines.clear();
    polylineCoordinates.clear();
    notifyListeners();
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    if (!googleMapController.isCompleted) {
      googleMapController.complete(controller);
      mapController = await googleMapController.future;
      notifyListeners();
    }
  }

  var userDestination = '';

  Future<webservice.PlacesDetailsResponse?> _getPrediction(
      webservice.Prediction? p) async {
    late webservice.PlacesDetailsResponse detail;
    try {
      if (p != null) {
        // get detail (lat/lng)
        webservice.GoogleMapsPlaces _places = webservice.GoogleMapsPlaces(
          apiKey: apiKey,
          apiHeaders: await const GoogleApiHeaders().getHeaders(),
        );
        detail = await _places.getDetailsByPlaceId(p.placeId!);
      }
    } on Exception catch (e) {
      log(e.toString());
    }
    return detail;
  }

  Future<void> onAppStarted() async {
    mapController = await googleMapController.future;
    late Position currentPosition;

    try {
      currentPosition = await _getGeoLocationPosition();
    } on Exception catch (e) {
      log(e.toString());
    }
    await mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(currentPosition.latitude, currentPosition.longitude),
        14,
      ),
    );
    try {
      address = await _getAddressFromLatLong(currentPosition);
    } on Exception catch (e) {
      log(e.toString());
    }
    sourceTextController.text =
        address.locality == "" ? "Location error" : address.locality;
    coordinates = coordinates.copyWith(
      sourceLatitude: currentPosition.latitude,
      sourceLongitude: currentPosition.longitude,
      destinationLatitude: 0,
      destinationLongitude: 0,
    );

    notifyListeners();
  }

  Future<void> setNewCurrentLocation(webservice.Prediction? p) async {
    _resetMap();
    webservice.PlacesDetailsResponse? detail = await _getPrediction(p);

    userDestination =
        sourceTextController.text = detail?.result.formattedAddress ?? '';

    coordinates = coordinates.copyWith(
      sourceLatitude: detail?.result.geometry?.location.lat,
      sourceLongitude: detail?.result.geometry?.location.lng,
    );
    _resetMap();
    notifyListeners();
  }

  Future<void> getUserLocation(webservice.Prediction? p) async {
    webservice.PlacesDetailsResponse? detail = await _getPrediction(p);
    sourceTextController.text = detail?.result.formattedAddress ?? '';
    debugPrint(detail?.result.geometry?.location.toString());
    var lng = detail?.result.geometry?.location.lng;
    var lat = detail?.result.geometry?.location.lat;

    coordinates = coordinates.copyWith(
      sourceLatitude: lat,
      sourceLongitude: lng,
      destinationLatitude: lat,
      destinationLongitude: lng,
    );
    await mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(
            coordinates.destinationLatitude, coordinates.destinationLongitude),
        14,
      ),
    );
    notifyListeners();
  }

  Future<void> getDestinationLocation(webservice.Prediction? p) async {
    webservice.PlacesDetailsResponse? detail = await _getPrediction(p);

    userDestination =
        destinationTextController.text = detail?.result.formattedAddress ?? '';

    coordinates = coordinates.copyWith(
      destinationLongitude: detail?.result.geometry?.location.lng,
      destinationLatitude: detail?.result.geometry?.location.lat,
    );
    _resetMap();
    notifyListeners();
  }

  Future<List<PointLatLng>?> getRoute() async {
    await mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(
            coordinates.destinationLatitude, coordinates.destinationLongitude),
        14,
      ),
    );
    _addMarker(
        LatLng(
          coordinates.sourceLatitude,
          coordinates.sourceLongitude,
        ),
        "origin",
        BitmapDescriptor.defaultMarker);

    /// [destination] marker
    _addMarker(
        LatLng(
          coordinates.destinationLatitude,
          coordinates.destinationLongitude,
        ),
        "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    List<PointLatLng>? points = await _getPolyline();

    return points;
  }

  void onError(webservice.PlacesAutocompleteResponse value) {
    log(value.toString());
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
    notifyListeners();
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
    );
    polylines[id] = polyline;
    notifyListeners();
  }

  Future<List<PointLatLng>?> _getPolyline() async {
    PolylineResult? result;
    try {
      result = await polylinePoints.getRouteBetweenCoordinates(
        apiKey,
        PointLatLng(coordinates.sourceLatitude, coordinates.sourceLongitude),
        PointLatLng(
          coordinates.destinationLatitude,
          coordinates.destinationLongitude,
        ),
        travelMode: TravelMode.driving,
      );
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      }
      _addPolyLine();
    } on Exception catch (e) {
      log(e.toString());
    }

    return result?.points;
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    Position _position;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return _position;
  }

  Future<Address> _getAddressFromLatLong(Position position) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    // debugPrint(placeMarks.toString());
    Placemark place = placeMarks[0];
    return Address(
      street: place.street!,
      subLocality: place.subLocality!,
      locality: place.locality!,
      postalCode: place.postalCode!,
      country: place.country!,
    );
  }
}
