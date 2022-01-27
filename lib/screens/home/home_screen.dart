import 'package:buzz_ai/controllers/home_screen_controller/home_screen_controller.dart';
import 'package:buzz_ai/controllers/notifications/notifications_controller.dart';
import 'package:buzz_ai/models/home/coordinates/coordinates.dart';
import 'package:buzz_ai/services/bg_methods.dart';
import 'package:buzz_ai/services/config.dart';
import 'package:buzz_ai/widgets/widget_size.dart';
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


class _HomeScreenState extends State<HomeScreen> {
  double _mapOpacity = 0;
  Size _mapSize = const Size(0, 1);
  // ActivityRecognitionService activityRecognitionService = ActibasvityRecognitionService();
  List<PointLatLng>? points;

  @override
  void initState() {
    initializeBackgroundExecution();
    super.initState();
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
                  origin: from,
                  destination: to,
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
                            child: GoogleMap(
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

                              await value.getUserLocation(p);
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
                                components: []
                                apiKey: apiKey,
                                onError: (PlacesAutocompleteResponse value) {
                                  onError(value, context);
                                },
                              );
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