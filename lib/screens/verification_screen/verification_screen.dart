import 'dart:developer';
import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/screens/profile_screen/profile_screen.dart';
import 'package:buzz_ai/services/widgets/config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerificationScreen extends StatefulWidget {
  static const String iD = '/verification';

  const VerificationScreen({Key? key}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  var verificationFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    verificationFormKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
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
                      bool _result =
                          await Provider.of<AuthenticationController>(
                        context,
                        listen: false,
                      ).signInWithPhoneNumber(value);
                      if (_result) {
                        Navigator.pushReplacementNamed(
                          context,
                          ProfileScreen.iD,
                        );
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
                        ..onTap = () {
                          log('tapped');
                          Provider.of<AuthenticationController>(
                            context,
                            listen: false,
                          ).onFieldSubmitted;
                        },
                      text: " Resend Again",
                      style: const TextStyle(
                        color: defaultColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void validateVerificationForms() {
    if (verificationFormKey.currentState!.validate()) {
      verificationFormKey.currentState?.save();
    }
  }
}
