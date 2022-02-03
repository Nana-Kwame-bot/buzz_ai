import 'dart:async';
import 'dart:developer';

import 'package:buzz_ai/activity_recognition.dart';
import 'package:buzz_ai/services/upload_watcher.dart';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

void onIosBackground() {
  WidgetsFlutterBinding.ensureInitialized();
  log('FLUTTER BACKGROUND FETCH');
}

final ActivityRecognitionApp activityRecognitionApp = ActivityRecognitionApp();
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

  activityRecognitionApp.init();
  startUploadWatcher();
}
