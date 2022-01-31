import 'dart:async';
import 'dart:developer';
import 'dart:io';

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
import 'package:shared_preferences/shared_preferences.dart';

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
  Timer.periodic(const Duration(minutes: 15), (timer) async {
    if (!(await service.isServiceRunning())) timer.cancel();
    service.setNotificationInfo(
      title: "Buzz.AI is running",
      content: "Updated at ${DateTime.now()}",
    );

    service.sendData(
      {"current_date": DateTime.now().toIso8601String()},
    );
  });

  activityRecognitionApp.init();
  startUploadWatcher();
}

void startUploadWatcher() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Stream<ConnectivityResult> connectivityStream =
      Connectivity().onConnectivityChanged;

  Timer.periodic(const Duration(seconds: 3), (timer) async {
    connectivityStream.listen((ConnectivityResult result) async {
      bool isOnline =
          [ConnectivityResult.mobile, ConnectivityResult.wifi].contains(result);

      if (isOnline) {
        // Upload pending sensorData as soon as device is online
        Directory dir = await getApplicationDocumentsDirectory();
        String path = dir.path;
        List<FileSystemEntity> pendingUploads = dir.listSync(recursive: true);
        pendingUploads.removeWhere((file) => !file.path.contains("sensor"));

        if (pendingUploads.isNotEmpty) {
          for (var pendingFile in pendingUploads) {
            File file = File(pendingFile.path);
            await uploadSensorData(file);
          }
        }

        DateTime now = DateTime.now();
        if (now.hour == 2 && now.minute >= 30) {
          // Upload current data if its 2:30
          await uploadSensorData();
        }
      }
    });
  });
}

Future<String> readSensorData([File? infile]) async {
  Directory dir = await getApplicationDocumentsDirectory();
  DateTime today = DateTime.now();
  File file = infile ??
      File(
          "${dir.path}/sensordata-${today.day}-${today.month}-${today.year}.csv");

  return await file.readAsString();
}

bool _sensorDataUploaded = false;
Future<void> uploadSensorData([File? file]) async {
  if (_sensorDataUploaded) return;

  String uid = FirebaseAuth.instance.currentUser!.uid;

  String data = await readSensorData(file);
  DateTime today = DateTime.now();

  TaskSnapshot sensorDataUploadTask = await FirebaseStorage.instance
      .ref(uid)
      .child("sensor_data")
      .child("${today.day}-${today.month}-${today.year}.csv")
      .putString(data, format: PutStringFormat.raw);

  await FirebaseFirestore.instance.collection("userDatabase").doc(uid).set(
    {
      "sensorData": FieldValue.arrayUnion([
        {
          "timestamp": DateTime.now(),
          "filePath": await sensorDataUploadTask.ref.getDownloadURL()
        }
      ])
    },
    SetOptions(merge: true),
  );
  Directory dir = await getApplicationDocumentsDirectory();
  if (file == null) {
    await File(
            "${dir.path}/sensordata-${today.day}-${today.month}-${today.year}.csv")
        .delete();
    return;
  }
  await file.delete();
}
