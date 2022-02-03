import 'dart:developer';

import 'package:buzz_ai/services/upload_watcher.dart';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:sensors_plus/sensors_plus.dart';

void onIosBackground() {
  WidgetsFlutterBinding.ensureInitialized();
  log('FLUTTER BACKGROUND FETCH');
}

void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();

  service.onDataReceived.listen((event) {
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
  });

  // bring to foreground
  service.setForegroundMode(true);

  startUploadWatcher();
  watchSensors();
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

    counter++;

    if (counter >= 50) {
      double currentAvgX = totalX / counter;
      double currentAvgY = totalY / counter;
      double currentAvgZ = totalZ / counter;

      double diffX = currentAvgX - targetX;
      double diffY = currentAvgY - targetY;
      double diffZ = currentAvgZ - targetZ;

      print([diffX.abs(), diffY.abs(), diffZ.abs()]);

      counter = 0;
    }
  });
}
