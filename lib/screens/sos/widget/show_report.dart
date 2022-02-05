import 'package:buzz_ai/screens/bottom_navigation/bottom_navigation.dart';
import 'package:flutter/material.dart';

void showReport(BuildContext context) {
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