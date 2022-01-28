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
      Map locationData = await getLocation();
      String uid = Provider.of<AuthenticationController>(context, listen: false)
          .auth
          .currentUser!
          .uid;

      widget.data = {
        "coordinates": [
          locationData["position"].latitude,
          locationData["position"].longitude
        ],
        "createdAt": DateTime.now(),
        "location": locationData["placemark"].toJson(),
        "uid": uid,
        "crashStatus": "Crash",
      };
    }

    Future<void> uploadReport() async {
      ActivityRecognitionApp ara =
          Provider.of<ActivityRecognitionApp>(context, listen: false);

      setState(() {
        _uploading = true;
      });

      if (widget.data == null) {
        await getData();
      }

      final ref = FirebaseStorage.instance
          .ref(widget.data!["uid"])
          .child("audio")
          .child(ara.fileName.split("/").last);
      await ref.putFile(File(ara.fileName));
      var url = await ref.getDownloadURL();

      widget.data!["audio"] = url;

      await FirebaseFirestore.instance
          .collection("accidentDatabase")
          .add(widget.data!);

      setState(() {
        _uploading = false;
      });

      Provider.of<ActivityRecognitionApp>(context, listen: false)
          .accidentReported = true;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const BottomNavigation(),
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
                              uploadReport();
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
                              uploadReport();
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
                              widget.data!["crashStatus"] = "Crash";
                              uploadReport();
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
