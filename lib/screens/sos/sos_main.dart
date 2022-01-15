import 'dart:async';

import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/screens/sos/sos_second_screen.dart';
import 'package:buzz_ai/services/get_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_progress_indicator/gradient_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SOSScreen extends StatefulWidget {
  const SOSScreen({Key? key}) : super(key: key);

  @override
  _SOSScreenState createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {
  String _positiveText = "YES";
  Map<String, dynamic>? data;
  final int timeout = 2;
  late Stream<int> timerStream;

  @override
  void initState() {
    timerStream = timer(timeout);
    getData();
    super.initState();
  }

  Future<void> getData() async {
    Map locationData = await getLocation();
    String uid = Provider.of<AuthenticationController>(context, listen: false)
        .auth
        .currentUser!
        .uid;

    data = {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF800003), Color(0xFF610080)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.4, 1.0],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 60),
              child: Text(
                "Do you need help?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
            StreamBuilder<int>(
                stream: timerStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.data == 0) uploadReport();

                    return GradientProgressIndicator(
                      child: Text(
                        snapshot.data!.toString(),
                        style: GoogleFonts.barlow(
                            color: Colors.white,
                            fontSize: 60,
                            fontWeight: FontWeight.w700),
                      ),
                      radius: 100,
                      strokeWidth: 15,
                      gradientStops: const [0, 1],
                      gradientColors: const [Colors.transparent, Colors.white],
                      duration: 2,
                    );
                  }

                  return GradientProgressIndicator(
                    child: Container(),
                    radius: 100,
                    strokeWidth: 15,
                    gradientStops: const [0, 1],
                    gradientColors: const [Colors.transparent, Colors.white],
                    duration: 2,
                  );
                }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  ConfirmationSlider(
                    onConfirmation: uploadReport,
                    text: _positiveText,
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
                  const SizedBox(height: 30),
                  ConfirmationSlider(
                    onConfirmation: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SOSSecondPage(data: data),
                      ),
                    ),
                    text: "NO",
                    textStyle: GoogleFonts.barlow(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    sliderButtonContent: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.asterisk,
                        color: Colors.red,
                        size: 25,
                      ),
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stream<int> timer(int seconds) async* {
    for (int i = seconds; i >= 0; i--) {
      yield i;
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future<void> uploadReport() async {
    if (data == null) {
      await getData();
    }

    await FirebaseFirestore.instance.collection("accidentDatabase").add(data!);
  }
}
