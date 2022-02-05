import 'package:buzz_ai/activity_recognition.dart';
import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/controllers/profile/user_profile/user_profile_controller.dart';
import 'package:buzz_ai/controllers/sos/sos_controller.dart';
import 'package:buzz_ai/models/accident_data/accident_data.dart';
import 'package:buzz_ai/screens/sos/widget/show_report.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class SOSSecondPage extends StatefulWidget {
  const SOSSecondPage({Key? key}) : super(key: key);

  @override
  _SOSSecondPageState createState() => _SOSSecondPageState();
}

class _SOSSecondPageState extends State<SOSSecondPage> {
  bool _uploading = false;
  AccidentData accidentData = AccidentData(
    longitude: 0,
    latitude: 0,
    timeCreated: DateTime.now(),
    placemark: Placemark(),
    crashStatus: "",
    last30sG: [],
    audioURL: "",
    gForce: 0,
  );
  late SOSController _sosController;
  late AuthenticationController _authenticationController;
  late ActivityRecognitionApp _activityRecognitionApp;
  late UserProfileController _userProfileController;

  @override
  void initState() {
    super.initState();
    _sosController = Provider.of<SOSController>(context, listen: false);
    _authenticationController =
        Provider.of<AuthenticationController>(context, listen: false);
    _activityRecognitionApp =
        Provider.of<ActivityRecognitionApp>(context, listen: false);
    _userProfileController =
        Provider.of<UserProfileController>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    String? userName = _userProfileController.userProfile.basicDetail!.fullName;

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
                        "${userName ?? "hey"} are you OK? What happened?",
                        style: GoogleFonts.barlow(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Column(
                        children: [
                          ConfirmationSlider(
                            onConfirmation: () async =>
                                await upload("No Crash"),
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
                            onConfirmation: () async =>
                                await upload("Minor Crash"),
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
                            onConfirmation: () async => await upload("Crash"),
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

  upload(String crashStatus) async {
    _sosController.upDateCrashStatus(crashStatus);
    Future upload = _sosController.uploadReport(
      recognitionApp: _activityRecognitionApp,
      userID: _authenticationController.auth.currentUser!.uid,
      userProfile: _userProfileController.userProfile,
    );
    setState(() => _uploading = true);

    upload.then((value) => showReport(context));
  }
}
