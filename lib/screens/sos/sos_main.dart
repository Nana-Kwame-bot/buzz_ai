import 'dart:async';
import 'dart:developer';

import 'package:buzz_ai/activity_recognition.dart';
import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/screens/bottom_navigation/bottom_navigation.dart';
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
  const SOSScreen({Key? key, this.timeout = 30}) : super(key: key);

  final int timeout;

  @override
  _SOSScreenState createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {
  String _positiveText = "YES";
  Map<String, dynamic>? data;
  late Stream<int> timerStream;
  bool _uploadStarted = false;
  bool _userConfirmsNoCrash = false;
  late ActivityRecognitionApp _activityProvider;

  @override
  void initState() {
    _activityProvider =
        Provider.of<ActivityRecognitionApp>(context, listen: false);
    timerStream = timer(widget.timeout);
    getData();
    super.initState();
  }

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

    data = {
      "coordinates": locationData == null
          ? null
          : [
              locationData["position"].latitude,
              locationData["position"].longitude
            ],
      "createdAt": DateTime.now(),
      "location":
          locationData == null ? null : locationData["placemark"].toJson(),
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
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: "Detected ",
                style: GoogleFonts.barlow(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: _activityProvider.excedeedGForce == null
                    ? "0"
                    : _activityProvider.excedeedGForce!.toStringAsFixed(1),
                style: GoogleFonts.barlow(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: " G's",
                style: GoogleFonts.barlow(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ])),
            StreamBuilder<int>(
                stream: timerStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
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
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Text("...",
                        style: TextStyle(fontSize: 50, color: Colors.white));
                  } else if (snapshot.data == 0 &&
                      snapshot.connectionState == ConnectionState.done) {
                    if (_uploadStarted) return Container();
                    WidgetsBinding.instance!
                        .addPostFrameCallback((timeStamp) => uploadReport());
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
                    onConfirmation: () {
                      _userConfirmsNoCrash = true;
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => SOSSecondPage(data: data),
                        ),
                      );
                    },
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
    _uploadStarted = true;
    setState(() {
      _positiveText = "Uploading...";
    });

    if (_userConfirmsNoCrash) {
      setState(() {
        _positiveText = "Not a Crash";
      });
      return;
    }

    if (data == null) {
      await getData();
    }
    data!["gForce"] = _activityProvider.excedeedGForce;

    await FirebaseFirestore.instance.collection("accidentDatabase").add(data!);

    setState(() {
      _positiveText = "Done.";
    });

    Provider.of<ActivityRecognitionApp>(context, listen: false)
        .accidentReported = true;
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
}
