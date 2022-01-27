import 'dart:async';
import 'dart:developer';

import 'package:buzz_ai/services/config.dart';
import 'package:buzz_ai/widgets/widget_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWithRoute extends StatefulWidget {
  const GoogleMapWithRoute({Key? key, required this.points}) : super(key: key);

  final List<Map<String, dynamic>> points;

  @override
  _GoogleMapWithRouteState createState() => _GoogleMapWithRouteState();
}

class _GoogleMapWithRouteState extends State<GoogleMapWithRoute> {
  double _mapOpacity = 0;
  Size _mapSize = const Size(0, 1);
  late GoogleMapController mapController;
  final Completer<GoogleMapController> googleMapController = Completer();
  final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: _mapOpacity,
      child: WidgetSize(
        onChange: (Size size) {
          setState(() {
            _mapSize = size;
          });
        },
        child: GoogleMap(
          padding: EdgeInsets.only(top: _mapSize.height - 150),
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target:
                LatLng(widget.points.first["lat"], widget.points.first["lng"]),
            zoom: 0,
          ),
          myLocationEnabled: true,
          compassEnabled: true,
          tiltGesturesEnabled: false,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          markers: Set<Marker>.of(markers.values),
          polylines: Set<Polyline>.of(polylines.values),
          onMapCreated: (controller) {
            if (mounted) {
              setState(() {
                _mapOpacity = 1;
              });
            }
            onMapCreated(controller);
            Future.delayed(Duration.zero, () async {
              await getRoute();
              setState(() {});
            });
          },
        ),
      ),
    );
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    if (!googleMapController.isCompleted) {
      googleMapController.complete(controller);
      mapController = await googleMapController.future;
    }
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 8,
      patterns: [PatternItem.dash(40), PatternItem.gap(20)]
    );
    polylines[id] = polyline;
  }

  Future<List<PointLatLng>?> _getPolyline() async {
    PolylineResult? result;
    try {
      result = await polylinePoints.getRouteBetweenCoordinates(
        apiKey,
        PointLatLng(widget.points.first["lat"], widget.points.first["lng"]),
        PointLatLng(widget.points.last["lat"], widget.points.last["lng"]),
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

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  Future<List<PointLatLng>?> getRoute() async {
    await mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(widget.points.last["lat"], widget.points.last["lng"]),
        (widget.points.length * 0.035).toDouble(),
      ),
    );
    _addMarker(LatLng(widget.points.first["lat"], widget.points.first["lng"]),
        "origin", BitmapDescriptor.defaultMarker);

    /// [destination] marker
    _addMarker(LatLng(widget.points.last["lat"], widget.points.last["lng"]),
        "destination", BitmapDescriptor.defaultMarkerWithHue(90));
    List<PointLatLng>? points = await _getPolyline();

    return points;
  }
}
