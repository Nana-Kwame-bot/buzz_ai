import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/screens/login/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubmitForm extends StatelessWidget {
  const SubmitForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        bottom: 32.0,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: const Color(0xFF5247C5),
            shape: const StadiumBorder(),
            minimumSize: const Size(100, 35)),
        onPressed: () {
          Provider.of<AuthenticationController>(
            context,
            listen: false,
          ).auth.signOut().whenComplete(() {
            Navigator.pushReplacementNamed(context, LoginScreen.iD);
          });
        },
        child: const Text('SUBMIT'),
      ),
    );
  }
}
