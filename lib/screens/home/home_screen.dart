import 'package:buzz_ai/controllers/home_screen_controller/home_screen_controller.dart';
import 'package:buzz_ai/services/widgets/config.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
                    height: constraints.maxHeight * 0.2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        40.0,
                        16.0,
                        40.0,
                        8.0,
                      ),
                      child: Column(
                        children: const [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                icon: Icon(Icons.my_location),
                                border: OutlineInputBorder(),
                                hintText: 'Your Location',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                icon: Icon(Icons.place),
                                border: OutlineInputBorder(),
                                hintText: 'Destination',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.8,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: value.kGooglePlex,
                        onMapCreated: (GoogleMapController controller) {
                          value.controller.complete(controller);
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: accentColor,
            onPressed: value.showRouteLines,
            child: const Icon(
              Icons.navigation,
              color: Colors.white,
              size: 40.0,
            ),
          ),
        );
      },
    );
  }
}
