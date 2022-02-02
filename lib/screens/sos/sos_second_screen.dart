import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/screens/sos/service/get_location.dart';
import 'package:buzz_ai/screens/sos/service/upload_report.dart';
import 'package:buzz_ai/screens/sos/widget/show_report.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class SOSSecondPage extends StatefulWidget {
  SOSSecondPage({Key? key, required this.data}) : super(key: key);

  @override
  _SOSSecondPageState createState() => _SOSSecondPageState();

  Map<String, dynamic> data = {};
}

class _SOSSecondPageState extends State<SOSSecondPage> {
  bool _uploading = false;

  @override
  Widget build(BuildContext context) {
    User? userName =
        Provider.of<AuthenticationController>(context).auth.currentUser;

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
    if (widget.data.keys.length < 4) {
      widget.data = await getData(context);
    }

    widget.data["crashStatus"] = crashStatus;
    Future upload = uploadReport(context, widget.data);
    setState(() => _uploading = true);

    upload.then((value) => showReport(context));
  }
}
