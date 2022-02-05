import 'dart:io';

import 'package:buzz_ai/activity_recognition.dart';
import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/screens/bottom_navigation/bottom_navigation.dart';
import 'package:buzz_ai/services/get_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class SOSSecondPage extends StatefulWidget {
  SOSSecondPage({Key? key, this.data}) : super(key: key);

  @override
  _SOSSecondPageState createState() => _SOSSecondPageState();

  Map<String, dynamic>? data = {};
}

class _SOSSecondPageState extends State<SOSSecondPage> {
  bool _uploading = false;

  @override
  Widget build(BuildContext context) {
    widget.data ??= {};
    User? userName =
        Provider.of<AuthenticationController>(context).auth.currentUser;

    Future<void> getData() async {
      Map? locationData;

      try {
        locationData = await getLocation();
      } catch (e) {
        locationData = null;
        // rethrow;
      }

      String uid = Provider.of<AuthenticationController>(context, listen: false)
          .auth
          .currentUser!
          .uid;
      List<double> last30sG =
          Provider.of<ActivityRecognitionApp>(context, listen: false)
              .last30GForce;

      widget.data = {
        "coordinates": locationData == null
            ? null
            : [
                locationData["position"].latitude,
                locationData["position"].longitude
              ],
        "createdAt": DateTime.now(),
        "location": locationData?["placemark"].toJson(),
        "uid": uid,
        "crashStatus": "Crash",
        "last30sG": last30sG,
      };
    }

    Future<void> uploadReport() async {
      ActivityRecognitionApp ara =
          Provider.of<ActivityRecognitionApp>(context, listen: false);
      String path = (await getApplicationDocumentsDirectory()).path;

      setState(() {
        _uploading = true;
      });

      if (widget.data == null) {
        await getData();
      } else if (widget.data!.keys.length < 4) {
        await getData();
      }

      final ref = FirebaseStorage.instance
          .ref(widget.data!["uid"])
          .child("audio/${ara.fileName}");

      File audioFile = File("$path/${ara.fileName}");
      await ref.putFile(audioFile);
      var url = await ref.getDownloadURL();
      audioFile.delete();

      widget.data!["audio"] = url;

      await FirebaseFirestore.instance
          .collection("accidentDatabase")
          .add(widget.data!);

      setState(() {
        _uploading = false;
      });

      Provider.of<ActivityRecognitionApp>(context, listen: false)
          .accidentReported = true;
    }

    void showReport() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Report uploaded!"),
          content: const Text(
              "We have detected a abnormal increase in G-force and we suspect this is a accident. We have upload your current location with a 3 second audio clip."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).popAndPushNamed(BottomNavigation.iD);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Visibility(
              visible: _uploading,
              child: const LinearProgressIndicator(),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF800003), Color(0xFF610080)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [0.4, 1.0],
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${userName == null ? "hey" : userName.displayName} are you OK? What happened?",
                        style: GoogleFonts.barlow(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Column(
                        children: [
                          ConfirmationSlider(
                            onConfirmation: () {
                              widget.data!["crashStatus"] = "No Crash";
                              uploadReport().then((value) => showReport());
                            },
                            text: "No crash",
                            textStyle: GoogleFonts.barlow(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            sliderButtonContent: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.carCrash,
                                color: Colors.white,
                              ),
                            ),
                            foregroundColor: const Color(0xAA6055e8),
                            backgroundColor: Colors.white.withOpacity(0.3),
                          ),
                          const SizedBox(height: 20),
                          ConfirmationSlider(
                            onConfirmation: () {
                              widget.data!["crashStatus"] = "Minor Crash";
                              uploadReport().then((value) => showReport());
                            },
                            text: "Minor crash",
                            textStyle: GoogleFonts.barlow(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            sliderButtonContent: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.userInjured,
                                color: Colors.black,
                              ),
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.white.withOpacity(0.3),
                          ),
                          const SizedBox(height: 20),
                          ConfirmationSlider(
                            onConfirmation: () {
                              // widget.data!["crashStatus"] = "Crash";
                              uploadReport().then((value) => showReport());
                            },
                            text: "SOS",
                            textStyle: GoogleFonts.barlow(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            sliderButtonContent: Center(
                              child: Text(
                                "SOS",
                                style: GoogleFonts.firaSans(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            foregroundColor: Colors.red,
                            backgroundColor: Colors.white.withOpacity(0.3),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
