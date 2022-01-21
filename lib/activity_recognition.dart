// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:bringtoforeground/bringtoforeground.dart';
import 'package:buzz_ai/models/sensors/sensor_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityRecognitionApp with ChangeNotifier {
  StreamSubscription<ActivityEvent>? activityStreamSubscription;
  final List<ActivityEvent> _events = [];
  ActivityRecognition activityRecognition = ActivityRecognition();
  ActivityEvent? currentActivityEvent;
  ActivityEvent? _lastActivityEvent;
  int initialRetryTimeout = 1;

  bool gForceExceeded = false;
  double? excedeedGForce;
  bool accidentReported = false;

  // Sensor variables
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  final List<List<double>> _accelerometerValues = [];
  final List<List<double>> _gyroscopeValues = [];
  DateTime _lastWritten = DateTime.now();
  late SharedPreferences prefs;
  List<double> last30GForce = [];
  double lastGForce = 0;

  int throttleAmount = 66; // In milliseconds.

  void initState() {
    init();
    _events.add(ActivityEvent.unknown());
  }

  @override
  void dispose() {
    activityStreamSubscription?.cancel();
    super.dispose();
  }

  void init() async {
    prefs = await SharedPreferences.getInstance();
    Timer.periodic(const Duration(seconds: 1), (timer) => last30GForce = []);

    _streamSubscriptions.addAll(
      [
        userAccelerometerEvents.listen(
          (UserAccelerometerEvent event) {
            lastGForce = checkGForce(event);

            if (lastGForce > 4) {
              if (!gForceExceeded) {
                gForceExceeded = true;
                excedeedGForce = lastGForce;
                Bringtoforeground.bringAppToForeground();
                notifyListeners();

                Future.delayed(const Duration(seconds: 10)).then((value) {
                  gForceExceeded = false;
                  accidentReported = false;
                });
              }
            }

            _throttle(
                updateSensorValues, "acc", <double>[event.x, event.y, event.z]);
          },
        ),
        gyroscopeEvents.listen(
          (GyroscopeEvent event) {
            _throttle(updateSensorValues, "gyro",
                <double>[event.x, event.y, event.z]);
          },
        ),
      ],
    );

    // Android requires explicitly asking permission
    if (Platform.isAndroid) {
      if (await Permission.activityRecognition.request().isGranted) {
        startTracking();
      }
    }

    // iOS does not
    else {
      startTracking();
    }

    Timer.periodic(const Duration(seconds: 3), (timer) async {
      DateTime now = DateTime.now();

      if (now.hour == 2 && now.minute >= 30) {
        Connectivity()
            .onConnectivityChanged
            .listen((ConnectivityResult result) async {
          if ([ConnectivityResult.mobile, ConnectivityResult.wifi]
              .contains(result)) {
            String path = (await getApplicationDocumentsDirectory()).path;

            if (prefs.getBool("sensorUploadPending") ?? false) {
              List<String> allPendingUploads =
                  prefs.getStringList("sensorDataPendingUploads") ?? [];

              for (var pendingFile in allPendingUploads) {
                File file = File("$path/$pendingFile");
                await uploadSensorData(file);
              }
              prefs.setStringList("sensorDataPendingUploads", []);
            }
            await uploadSensorData();
          } else {
            // Queue all pending files
            DateTime today = DateTime.now();
            await prefs.setBool("sensorUploadPending", true);
            List<String> allPendingUploads = [
              "sensordata-${today.day}-${today.month}-${today.year}.csv",
            ];

            allPendingUploads
                .addAll(prefs.getStringList("sensorDataPendingUploads") ?? []);

            await prefs.setStringList(
              "sensorDataPendingUploads",
              allPendingUploads,
            );
          }
        });
      }
    });
  }

  DateTime lastUpdate = DateTime.now();
  _throttle(Function callback, String sensor, List<double> event) async {
    if (DateTime.now().difference(lastUpdate).inMilliseconds < throttleAmount)
      return;

    callback(sensor, event);
    // dev.log("Callback called after being throttled for [${DateTime.now().difference(lastUpdate).inMilliseconds}'ms]");
    lastUpdate = DateTime.now();
  }

  void startTracking() {
    activityStreamSubscription = activityRecognition
        .activityStream(runForegroundService: true)
        .listen(onData, onError: onError);
  }

  void onData(ActivityEvent activityEvent) {
    _lastActivityEvent = currentActivityEvent;
    currentActivityEvent = activityEvent;

    _events.add(activityEvent);
  }

  void onError(Object error) {
    print('ERROR - $error');
  }

  double checkGForce(UserAccelerometerEvent event) {
    // sqrt(x^2 + y^2 + z^2)

    double gForce =
        sqrt(pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2)) / 9.81;

    return gForce;
  }

  void updateSensorValues(String event, List<double> data) async {
    last30GForce.add(lastGForce);

    if (currentActivityEvent == null) return;
    if (_lastActivityEvent == null) return;

    if (currentActivityEvent!.type == ActivityType.ON_FOOT) {
      if (event == "acc") {
        _accelerometerValues.add(data);
      }
      if (event == "gyro") {
        _gyroscopeValues.add(data);
      }

      dev.log(data.toString());
    } else if (currentActivityEvent!.type == ActivityType.STILL) {
      if (_lastActivityEvent!.type != ActivityType.STILL) {
        // This inequality makes sure that we write only once
        _lastActivityEvent = currentActivityEvent;

        if (_lastWritten.difference(DateTime.now()).inSeconds < 4) {
          await writeSensorData();
        }

        dev.log("Writing sensor data to box");
      }
    }
  }

  Future<void> writeSensorData() async {
    Directory dir = await getApplicationDocumentsDirectory();
    DateTime today = DateTime.now();
    File file = File(
        "${dir.path}/sensordata-${today.day}-${today.month}-${today.year}.csv");

    String data = "";
    if (!(await file.exists())) {
      data = "Accx, Accy, Accz, Gyrox, Gyroy, Gyroz\n";
    }

    for (int i = 0, j = 0; i < _accelerometerValues.length; i++, j++) {
      data +=
          "${_accelerometerValues[i][0]}, ${_accelerometerValues[i][1]}, ${_accelerometerValues[i][2]}, ";

      if (j < _gyroscopeValues.length) {
        data +=
            "${_gyroscopeValues[j][0]}, ${_gyroscopeValues[j][1]}, ${_gyroscopeValues[j][2]}\n";
      } else {
        data += "0, 0, 0\n";
      }
    }

    await file.writeAsString(data.toString(), mode: FileMode.append);
    _lastWritten = DateTime.now();
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

    String data = await readSensorData();
    DateTime today = DateTime.now();

    TaskSnapshot sensorDataUploadTask = await FirebaseStorage.instance
        .ref(uid)
        .child("sensor_data")
        .child("${today.day}-${today.month}-${today.year}.csv")
        .putString(data, format: PutStringFormat.raw);

    await FirebaseFirestore.instance
        .collection("userDatabase")
        .doc(uid)
        .update({
      "historyData": [],
      "sensorData": FieldValue.arrayUnion([
        {
          "timestamp": DateTime.now(),
          "filePath": await sensorDataUploadTask.ref.getDownloadURL()
        }
      ])
    });
    _sensorDataUploaded = true;
    Directory dir = await getApplicationDocumentsDirectory();
    await File(
            "${dir.path}/sensordata-${today.day}-${today.month}-${today.year}.csv")
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Activity Recognition'),
        ),
        body: Center(
          child: ListView.builder(
              itemCount: _events.length,
              reverse: true,
              itemBuilder: (_, int idx) {
                final activity = _events[idx];
                return ListTile(
                  leading: _activityIcon(activity.type),
                  title: Text(
                      '${activity.type.toString().split('.').last} (${activity.confidence}%)'),
                  trailing: Text(activity.timeStamp
                      .toString()
                      .split(' ')
                      .last
                      .split('.')
                      .first),
                );
              }),
        ),
      ),
    );
  }

  Icon _activityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.IN_VEHICLE:
        return Icon(Icons.car_rental);
      case ActivityType.RUNNING:
        return Icon(Icons.run_circle);
      case ActivityType.STILL:
        return Icon(Icons.cancel_outlined);
      case ActivityType.TILTING:
        return Icon(Icons.redo);
      default:
        return Icon(Icons.device_unknown);
    }
  }
}
