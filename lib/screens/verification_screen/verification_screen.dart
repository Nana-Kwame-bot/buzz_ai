import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/screens/profile_screen/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerificationScreen extends StatelessWidget {
  static const String iD = '/verification';
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: Provider.of<AuthenticationController>(context).onAuthStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return const ProfileScreen();
          }
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    autofocus: true,
                    onSubmitted: (String? value) async {
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
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('VERIFY'),
                  ),
                ],
              ),
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
