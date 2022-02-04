import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/routes/routes.dart';
import 'package:buzz_ai/screens/splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as location;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:developer';

import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:buzz_ai/activity_recognition.dart';
import 'package:provider/provider.dart';

bool locationTrackingStarted = false;

class BuzzaiApp extends StatelessWidget {
  const BuzzaiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _uploadPoints(context);

    return MaterialApp(
      onGenerateRoute: AppRouter().onGenerateRoute,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }

  Future<void> _uploadPoints(BuildContext context) async {
    locationTrackingStarted = true;
    Map data = {
      "timestamp": DateTime.now(),
      "routes": [],
    };
    String? uid = Provider.of<AuthenticationController>(context, listen: false)
        .auth
        .currentUser
        ?.uid;

    if (uid == null) return;

    List<Map> history = [];
    DateTime _lastStillTime = DateTime.now();

    // Listen for location events
    location.Location().onLocationChanged.listen(
      (event) async {
        if (event.latitude == null || event.longitude == null) return;
        ActivityEvent? currentActivity =
            Provider.of<ActivityRecognitionApp>(context, listen: false)
                .currentActivityEvent;

        if (currentActivity != null &&
            currentActivity.type == ActivityType.ON_FOOT) {
          // If user moves append the lat and lng to the history
          log("Moving now!");

          Map temp = {"lat": event.latitude, "lng": event.longitude};
          Map lastTemp = {};

          if (temp != lastTemp) {
            history.add(temp);
            lastTemp = temp;
          }
        } else {
          // If not moving
          // log("Not moving");

          data["toTime"] = DateTime.now();
          int _stillFor = DateTime.now().difference(_lastStillTime).inSeconds;
          if (_stillFor < 10)
            return; // Dont upload the data untill the user is STILL for 10 minutes
          if (history.toSet().isEmpty)
            return; // If history is empty dont upload

          _lastStillTime = DateTime.now();
          data["routes"] = history.toSet().toList();
          try {
            data["from"] = (await placemarkFromCoordinates(
                    history.toSet().first["lat"], history.toSet().first["lng"]))
                .first
                .locality;
            data["to"] = (await placemarkFromCoordinates(
                    history.toSet().last["lat"], history.toSet().last["lng"]))
                .first
                .locality;
          } catch (e) {
            data["from"] = null;
            data["to"] = null;
          }

          await FirebaseFirestore.instance
              .collection("userDatabase")
              .doc(uid)
              .set(
            {
              "historyData": {DateTime.now().toString(): data}
            },
            SetOptions(merge: true),
          );
          history = [];

          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 5,
              channelKey: 'alert',
              title: "Route uplaoded",
              body: "Route uploaded to firestore sucessfully!",
              autoDismissible: false,
              backgroundColor: Colors.green,
              criticalAlert: true,
              displayOnBackground: true,
            ),
            actionButtons: [
              NotificationActionButton(
                key: "open_route_page",
                label: "Open",
              ),
              NotificationActionButton(
                key: "dismiss",
                label: "Dismiss",
                isDangerousOption: true,
                buttonType: ActionButtonType.DisabledAction,
              ),
            ],
          );
        }
      },
    );
  }
}
