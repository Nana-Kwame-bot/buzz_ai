import 'package:buzz_ai/controllers/home_screen_controller/home_screen_controller.dart';
import 'package:buzz_ai/services/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:map_launcher/map_launcher.dart' as mapLauncher;
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenController>(
      builder: (BuildContext context, value, Widget? child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                children: [
                  SizedBox(
                    height: (constraints.maxHeight * 0.2) + 8.0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        40.0,
                        16.0,
                        40.0,
                        0.0,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: TextFormField(
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
                                icon: Icon(
                                  Icons.my_location,
                                  color: defaultColor,
                                ),
                                border: OutlineInputBorder(),
                                hintText: 'Your Location',
                              ),
                              enabled: true,
                              readOnly: true,
                              controller: value.sourceTextController,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Expanded(
                            child: TextFormField(
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
                                icon: Icon(
                                  Icons.place,
                                  color: Color(0xFFD1403C),
                                ),
                                border: OutlineInputBorder(),
                                enabled: true,
                                hintText: 'Destination',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    height: (constraints.maxHeight * 0.8) - 32.0,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: value.kGooglePlex,
                      myLocationEnabled: true,
                      compassEnabled: true,
                      tiltGesturesEnabled: false,
                      scrollGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                      markers: Set<Marker>.of(value.markers.values),
                      polylines: Set<Polyline>.of(value.polylines.values),
                      onMapCreated: value.onMapCreated,

                    ),
                  ),
                ],
              );
            },
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(right: 60),
            child: FloatingActionButton(
              backgroundColor: accentColor,
              onPressed: () async {
                List<mapLauncher.AvailableMap> availableMaps = await mapLauncher.MapLauncher.installedMaps;

                mapLauncher.Coords from = mapLauncher.Coords(value.coordinates.sourceLatitude, value.coordinates.sourceLongitude);
                mapLauncher.Coords to = mapLauncher.Coords(value.coordinates.destinationLatitude, value.coordinates.destinationLongitude);
                
                await availableMaps.first.showDirections(
                  origin: from,
                  destination: to,
                );
              },
              child: const Icon(
                Icons.navigation,
                color: Colors.white,
                size: 40.0,
              ),
            ),
          ),
        );
      },
    );
  }

  void onError(value, context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value.toString()),
      ),
    );
  }

}
