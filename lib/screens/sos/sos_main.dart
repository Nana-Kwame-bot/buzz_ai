import 'dart:async';
import 'package:buzz_ai/activity_recognition.dart';
import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/controllers/profile/user_profile/user_profile_controller.dart';
import 'package:buzz_ai/controllers/sos/sos_controller.dart';
import 'package:buzz_ai/screens/sos/sos_second_screen.dart';
import 'package:buzz_ai/screens/sos/widget/show_report.dart';
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
  late Stream<int> timerStream;
  bool _uploadStarted = false;
  bool _userConfirmsNoCrash = false;

  @override
  void initState() {
    super.initState();
    timerStream = timer(widget.timeout);
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
        child: Consumer4(
          builder: (
            BuildContext context,
            ActivityRecognitionApp recognitionApp,
            UserProfileController userProfileController,
            AuthenticationController authenticationController,
            SOSController sosController,
            Widget? child,
          ) {
            return Column(
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
                    text: recognitionApp.excedeedGForce == null
                        ? "0"
                        : recognitionApp.excedeedGForce!.toStringAsFixed(1),
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
                          gradientColors: const [
                            Colors.transparent,
                            Colors.white
                          ],
                          duration: 2,
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Text("...",
                            style:
                                TextStyle(fontSize: 50, color: Colors.white));
                      } else if (snapshot.data == 0 &&
                          snapshot.connectionState == ConnectionState.done) {
                        if (_uploadStarted) return Container();
                        // WidgetsBinding.instance!
                        //     .addPostFrameCallback((timeStamp) async {
                        //   if (data.keys.length < 4) {
                        //     data = await getData(context);
                        //   }
                        // });
                        sosController.uploadReport(
                          userProfile: userProfileController.userProfile,
                          userID:
                              authenticationController.auth.currentUser!.uid,
                          recognitionApp: recognitionApp,
                        );
                      }

                      return GradientProgressIndicator(
                        child: Container(),
                        radius: 100,
                        strokeWidth: 15,
                        gradientStops: const [0, 1],
                        gradientColors: const [
                          Colors.transparent,
                          Colors.white
                        ],
                        duration: 2,
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      ConfirmationSlider(
                        onConfirmation: () async {
                          // if (data.keys.length < 4) {
                          //   data = await getData(context);
                          // }
                          Future uploadStatus = sosController.uploadReport(
                            userProfile: userProfileController.userProfile,
                            userID:
                                authenticationController.auth.currentUser!.uid,
                            recognitionApp: recognitionApp,
                          );

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

                          if (mounted) {
                            uploadStatus.then((value) {
                              setState(() => _positiveText = "Done.");
                              showReport(context);
                            });
                          }
                        },
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
                              builder: (context) {
                                return const SOSSecondPage();
                              },
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
            );
          },
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
}
