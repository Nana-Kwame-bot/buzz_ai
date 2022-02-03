// ignore_for_file: unused_import

import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/routes/screen_arguments/profile_screen_arguments.dart';
import 'package:buzz_ai/screens/bottom_navigation/bottom_navigation.dart';
import 'package:buzz_ai/screens/misc/request_permission.dart';
import 'package:buzz_ai/screens/profile_screen/profile_screen.dart';
import 'package:buzz_ai/services/config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationScreen extends StatefulWidget {
  static const String iD = '/verification';

  const VerificationScreen({Key? key}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  var verificationFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Consumer<AuthenticationController>(
            builder: (BuildContext context, authController, Widget? child) {
              return Column(
                children: [
                  const SizedBox(
                    height: 60.0,
                  ),
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width / 4,
                    backgroundColor: const Color(0xFFF7F7F7),
                    child: Image.asset(
                      'assets/img/smartphone.jpg',
                    ),
                  ),
                  const Text(
                    'Verification',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'You will get OTP via',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: ' SMS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 82.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: verificationFormKey,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter OTP',
                          border: OutlineInputBorder(),
                        ),
                        autofocus: false,
                        textAlign: TextAlign.center,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your OTP';
                          }
                          return null;
                        },
                        onSaved: (String? value) async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          bool isProfileSet =
                              prefs.getBool("profileComplete") ?? false;

                          bool _result =
                              await authController.signInWithPhoneNumber(value);
                          if (_result) {
                            if (!isProfileSet) {
                              Navigator.of(context).pushReplacementNamed(
                                ProfileScreen.iD,
                                arguments: ProfileScreenArguments(
                                  isFromSignUp: true,
                                ),
                              );
                            } else {
                              if (prefs.getBool("allPermissionsGranted") ??
                                  false) {
                                Navigator.of(context).pushReplacementNamed(
                                  BottomNavigation.iD,
                                );
                                return;
                              }
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RequestPermission()));
                            }
                          } else {
                            final snackBar = SnackBar(
                              duration: const Duration(seconds: 3),
                              content: const Text(
                                'Invalid verification code',
                              ),
                              action: SnackBarAction(
                                label: 'Dismiss',
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                },
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 45.0,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: defaultColor),
                      onPressed: () {
                        validateVerificationForms();
                      },
                      child: const Text('VERIFY'),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Didn't receive the verification code?",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = authController.timedOut
                                ? () async {
                                    authController.resendOTP();
                                    final snackBar = SnackBar(
                                      duration: const Duration(seconds: 3),
                                      content: const Text(
                                        'Please check your phone for the verification code',
                                      ),
                                      action: SnackBarAction(
                                        label: 'OK',
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .clearSnackBars();
                                        },
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                : null,
                          text: " Resend Again",
                          style: TextStyle(
                            color: authController.timedOut
                                ? defaultColor
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    verificationFormKey.currentState?.dispose();
    super.dispose();
  }

  void validateVerificationForms() {
    if (verificationFormKey.currentState!.validate()) {
      verificationFormKey.currentState?.save();
    }
  }
}
