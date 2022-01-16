import 'package:buzz_ai/controllers/home_screen_controller/home_screen_controller.dart';
import 'package:buzz_ai/models/home/coordinates/coordinates.dart';
import 'package:buzz_ai/services/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:map_launcher/map_launcher.dart' as mapLauncher;
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _mapOpacity = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenController>(
      builder: (BuildContext context, value, Widget? child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                children: [
                  SizedBox(
                    height: (constraints.maxHeight * 0.2) + 8.0,
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
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.my_location,
                                color: defaultColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              hintText: 'Your Location',
                            ),
                            enabled: true,
                            readOnly: true,
                            controller: value.sourceTextController,
                          ),
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
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
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
                  const SizedBox(height: 16.0),
                  Container(
                    height: (constraints.maxHeight * 0.72) + 8.0,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    decoration:  const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 800),
                        opacity: _mapOpacity,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            GoogleMap(
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
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: SizedBox(
                                height: 50,
                                width: 130,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    String? destinationValid = validateDestination(value.coordinates);
                                    if (destinationValid != null) {
                                      showDialog(
                                        context: context, 
                                        builder: (context) => AlertDialog(
                                          title: const Text("Invalide destination"),
                                          content: Text(destinationValid),
                                        ),
                                      );
                                      return;
                                    }

                                    List<mapLauncher.AvailableMap> availableMaps = await mapLauncher.MapLauncher.installedMaps;

                                    mapLauncher.Coords from = mapLauncher.Coords(value.coordinates.sourceLatitude, value.coordinates.sourceLongitude);
                                    mapLauncher.Coords to = mapLauncher.Coords(value.coordinates.destinationLatitude, value.coordinates.destinationLongitude);
                                    
                                    await availableMaps.first.showDirections(
                                      origin: from,
                                      destination: to,
                                    );
                                  }, 
                                  child: const Text("Start"),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.lightGreen.withOpacity(0.8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
    if (coords.sourceLatitude.toInt() == coords.destinationLatitude.toInt() 
        && 
        coords.sourceLongitude.toInt() == coords.destinationLongitude.toInt()
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
