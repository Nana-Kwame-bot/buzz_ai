import 'dart:async';
import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:buzz_ai/activity_recognition.dart';
import 'package:buzz_ai/controllers/home_screen_controller/home_screen_controller.dart';
import 'package:buzz_ai/models/home/coordinates/coordinates.dart';
import 'package:buzz_ai/services/bg_methods.dart';
import 'package:buzz_ai/services/config.dart';
import 'package:buzz_ai/widgets/widget_size.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:map_launcher/map_launcher.dart' as map_launcher;
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  double _mapOpacity = 0;
  Size _mapSize = const Size(0, 1);
  // ActivityRecognitionService activityRecognitionService = ActibasvityRecognitionService();
  List<PointLatLng>? points;
  bool _onAppStartedSuccess = false;
  Stream<ReceivedAction> notificationActionStream = AwesomeNotifications().actionStream;

  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    initializeBackgroundExecution();
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    await Provider.of<ActivityRecognitionApp>(context, listen: false).init();

    try {
      notificationActionStream.listen((ReceivedNotification receivedNotification) {
        if (receivedNotification.toMap()["buttonPressed"] == "dismiss") {
          AwesomeNotifications().dismiss(receivedNotification.id!);
          return;
        }

        // Navigator.of(context).pushNamed('/NotificationPage',
        //     arguments: {"id": receivedNotification.id});
        log("App opened from notification: ${receivedNotification}");
        
        Provider.of<ActivityRecognitionApp>(context, listen: false).notificationShown = false;
      });

      AwesomeNotifications().dismissedStream.listen((event) { 
        
      });
    } catch (e) {}

    super.didChangeDependencies();
  }

  void initializeBackgroundExecution() async {
    FlutterBackgroundService bgService = FlutterBackgroundService();
    await bgService.configure(
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
        autoStart: true,
        onStart: onStart,
        isForegroundMode: true,
      ),
    );
  }

  @override
  void dispose() {
    // activityRecognitionService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Consumer<HomeScreenController>(
      builder: (BuildContext context, value, Widget? child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          floatingActionButton: Container(
            margin: const EdgeInsets.only(right: 40.0, bottom: 10.0 ),
            child: FloatingActionButton(
              onPressed: () async {
                String? destinationValid = validateDestination(value.coordinates);
                if (destinationValid != null) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                    title: const Text("Invalid destination"),
                    content: Text(destinationValid),
                    ),
                  );
                  return;
                }

                List<map_launcher.AvailableMap> availableMaps = await map_launcher.MapLauncher.installedMaps;

                map_launcher.Coords from = map_launcher.Coords(value.coordinates.sourceLatitude, value.coordinates.sourceLongitude);
                map_launcher.Coords to = map_launcher.Coords(value.coordinates.destinationLatitude, value.coordinates.destinationLongitude);

                await availableMaps.first.showDirections(
                  originTitle: value.sourceTextController.text,
                  origin: from,
                  destinationTitle: value.destinationTextController.text,
                  destination: to,
                  directionsMode: map_launcher.DirectionsMode.driving,
                );
              },
              child: const Icon(
                Icons.navigation_sharp,
                size: 30.0,
              ),
              backgroundColor: Colors.blueAccent,
            ),
          ),
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                children: [
                  SizedBox(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 800),
                      opacity: _mapOpacity,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          WidgetSize(
                            onChange: (Size size) {
                              setState(() {
                                _mapSize = size;
                              });
                            },
                            child: Consumer(
                              builder: (context, Object connectivityResult, child) {
                                if (connectivityResult.runtimeType == ConnectivityResult) {
                                  if (connectivityResult == ConnectivityResult.none) {
                                    _onAppStartedSuccess = false;
                                  } else {
                                    if (!_onAppStartedSuccess) {
                                      value.onAppStarted();
                                      _onAppStartedSuccess = true;
                                    }
                                  }
                                }
      
                                return GoogleMap(
                                  padding: EdgeInsets.only(top: _mapSize.height - 150),
                                  mapType: MapType.normal,
                                  initialCameraPosition: value.kGooglePlex,
                                  myLocationEnabled: true,
                                  compassEnabled: true,
                                  tiltGesturesEnabled: false,
                                  scrollGesturesEnabled: true,
                                  zoomGesturesEnabled: true,
                                  markers: Set<Marker>.of(value.markers.values),
                                  polylines: Set<Polyline>.of(value.polylines.values),
                                  onMapCreated: (controller) {
                                    setState(() {
                                      _mapOpacity = 1;
                                    });

                                    value.onMapCreated(controller);
                                  },
                                );
                              }
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        20.0,
                        16.0,
                        20.0,
                        0.0,
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            style: value.sourceTextController.text == "Location error" ? const TextStyle(color: Colors.red) : null,
                            onTap: () async {
                              Prediction? p = await PlacesAutocomplete.show(
                                offset: 0,
                                types: [],
                                strictbounds: false,
                                context: context,
                                mode: Mode.overlay,
                                language: "en",
                                components: []
                                apiKey: apiKey,
                                onError: (PlacesAutocompleteResponse value) {
                                  onError(value, context);
                                },
                              );

                              if (p == null) return;

                              await value.setNewCurrentLocation(p);

                              if (value.coordinates.destinationLatitude == 0 && value.coordinates.destinationLongitude == 0) {
                                await value.setMarkerAtSinglePoint(value.coordinates.sourceLatitude, value.coordinates.sourceLongitude);
                                return;
                              }
                              await value.getRoute();
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.my_location,
                                color: defaultColor,
                              ),
                              suffixIcon: Visibility(
                                visible: value.sourceTextController.text.isEmpty,
                                child:  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  ),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)
                                ),
                              ),
                              hintText: 'Your Location',
                            ),
                            enabled: true,
                            readOnly: true,
                            controller: value.sourceTextController,
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            onTap: () async {
                              Prediction? p = await PlacesAutocomplete.show(
                                offset: 0,
                                types: [],
                                strictbounds: false,
                                context: context,
                                mode: Mode.overlay,
                                language: "en",
                                components: [],
                                apiKey: apiKey,
                                onError: (PlacesAutocompleteResponse value) {
                                  onError(value, context);
                                },
                              );

                              if (p == null) return;

                              await value.getDestinationLocation(p);
                              await value.getRoute();
                            },
                            controller: value.destinationTextController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.place,
                                color: Color(0xFFD1403C),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)
                                ),
                              ),
                              enabled: true,
                              hintText: 'Destination',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  String? validateDestination(Coordinates coords) {
    
    if (coords.destinationLatitude == 0
        &&  coords.destinationLongitude == 0
        ) {
      return "Source and destination should be different!";
    }

    return null;
  }

  void onError(value, context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value.toString()),
      ),
    );
  }
}