/// The function [log] from `dart:developer` library is overridden to prefix the [log] with "BG: " to differentiate logs from foreground and from this isolate.
/// If you want to use the plain [log] function from `dart:developer` use [dev.log].

// ignore_for_file: unused_import

import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:buzz_ai/activity_recognition.dart';
import 'package:buzz_ai/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:buzz_ai/services/upload_watcher.dart';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:sensors_plus/sensors_plus.dart';

void log(
  String message, {
  DateTime? time,
  int? sequenceNumber,
  int level = 0,
  String name = '',
  Zone? zone,
  Object? error,
  StackTrace? stackTrace,
}) {
  dev.log(
    "BG: " + message,
    time: time,
    sequenceNumber: sequenceNumber,
    level: level,
    name: name,
    zone: zone,
    error: error,
    stackTrace: stackTrace,
  );
}

void onIosBackground() {
  WidgetsFlutterBinding.ensureInitialized();
  log('FLUTTER BACKGROUND FETCH');
}

void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();

  service.onDataReceived.listen((event) {
    print(event);

    if (event!["action"] == "setAsForeground") {
      service.setForegroundMode(true);
      return;
    }

    if (event["action"] == "setAsBackground") {
      service.setForegroundMode(false);
    }

    if (event["action"] == "stopService") {
      service.stopBackgroundService();
    }

    if (event["message"] == "detached") {
      watchSensors();
    }
  });

  // bring to foreground
  service.setForegroundMode(true);

  startUploadWatcher();
  sensors();
}

void watchSensors() {
  const targetX = 0.018938301;
  const targetY = -0.040060136;
  const targetZ = 0.042773451;

  double totalX = 0;
  double totalY = 0;
  double totalZ = 0;

  int counter = 0;

  userAccelerometerEvents.listen((UserAccelerometerEvent event) {
    totalX += event.x;
    totalY += event.y;
    totalZ += event.z;
    print(totalX);

    counter++;

    if (counter >= 50) {
      double currentAvgX = totalX / counter;
      double currentAvgY = totalY / counter;
      double currentAvgZ = totalZ / counter;

      double diffX = currentAvgX - targetX;
      double diffY = currentAvgY - targetY;
      double diffZ = currentAvgZ - targetZ;

      print("[${event.x}, ${event.y}, ${event.z}] <<<>>> [$currentAvgX, $currentAvgY, $currentAvgZ]  ==  Xdiff: $diffX, Ydiff: $diffY, Zdiff: $diffZ");

      if (diffX.abs() >= 1) {
        if (diffY.abs() >= 1) {
          if (diffZ.abs() >= 1) {
            AwesomeNotifications().createNotification(
              content: NotificationContent(
                id: 1,
                channelKey: 'activity_change',
                title: "Are you driving?",
                body:
                    "Please open the application if you're driving so that we can ensure your safety",
              ),
              actionButtons: [
                NotificationActionButton(
                  key: "open",
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
        }
      }

      counter = 0;
    }
  });
}

void sensors() {
  // userAccelerometerEvents.listen((UserAccelerometerEvent event) {
  //   log("${event.x + event.y + event.z}");
  // });
}
