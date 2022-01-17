import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';


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
  Timer.periodic(const Duration(minutes: 15), (timer) async {
    if (!(await service.isServiceRunning())) timer.cancel();
    service.setNotificationInfo(
      title: "My App Service",
      content: "Updated at ${DateTime.now()}",
    );

    service.sendData(
      {"current_date": DateTime.now().toIso8601String()},
    );
  });

  // Timer.periodic(const Duration(seconds: 1),
  //     (timer) async => activityRecognitionService.monitorActivity());
}
