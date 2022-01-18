// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:buzz_ai/models/sensors/sensor_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ActivityRecognitionApp with ChangeNotifier {
  StreamSubscription<ActivityEvent>? activityStreamSubscription;
  final List<ActivityEvent> _events = [];
  ActivityRecognition activityRecognition = ActivityRecognition();
  ActivityEvent? currentActivityEvent;
  ActivityEvent? _lastActivityEvent;

  bool gForceExceeded = false;
  bool accidentReported = false;

  // Sensor variables
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  List<List<double>> _accelerometerValues = [];
  List<List<double>> _gyroscopeValues = [];
  DateTime _lastWritten = DateTime.now();

  late Box<SensorModel> sensorBox;
  int throttleAmount = 500;  // In milliseconds.

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
    String path = (await getApplicationDocumentsDirectory()).path;
    Hive.init(path);
    Hive.registerAdapter(SensorModelAdapter());
    sensorBox = await Hive.openBox("sensor_data");

    _streamSubscriptions.addAll(
      [
        accelerometerEvents.listen(
          (AccelerometerEvent event) {
            if (checkGForce(event) > 4) {
              if (!gForceExceeded) {
                gForceExceeded = true;
                notifyListeners();
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

    Timer.periodic(const Duration(minutes: 30), (timer) async {
      DateTime now = DateTime.now();
      if (now.hour == 2 && now.minute >= 30) {
        await uploadSensorData();
      } else
        print('not 2:30');
    });
  }

  DateTime lastUpdate = DateTime.now();
  _throttle(Function callback, String sensor, List<double> event) async {
    if (DateTime.now().difference(lastUpdate).inMilliseconds < throttleAmount) return;

    callback(sensor, event);
    dev.log("$callback after being throttled for [${DateTime.now().difference(lastUpdate).inMilliseconds}]");
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

  double checkGForce(AccelerometerEvent event) {
    // sqrt(x^2 + y^2 + z^2)

    double gForce =
        sqrt(pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2)) / 9.81;

    return gForce;
  }

  void updateSensorValues(String event, List<double> data) async {
    if (currentActivityEvent == null) return;
    if (_lastActivityEvent == null) return;

    if (currentActivityEvent!.type == ActivityType.IN_VEHICLE) {
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
          await writeToBox();
        }

        dev.log("Writing sensor data to box");
      }
    }
  }

  Future<void> writeToBox() async {
    // await sensorBox.clear();
    DateTime today = DateTime.now();
    String date = "${today.day}-${today.month}-${today.year}";

    // read old data to prevent overwrite
    SensorModel? oldSensorModel = sensorBox.get(date);
    if (oldSensorModel != null) {
      List<List<double>> temp = _accelerometerValues;
      _accelerometerValues = [...oldSensorModel.accelerometerData, ...temp];

      temp = _gyroscopeValues;
      _gyroscopeValues = [...oldSensorModel.gyroscopeData, ...temp];
    }

    SensorModel sensorModel = SensorModel(
      at: date,
      accelerometerData: _accelerometerValues,
      gyroscopeData: _gyroscopeValues,
    );

    await sensorBox.put(date, sensorModel);
    _lastWritten = DateTime.now();
  }

  Future<SensorModel?> readFromBox() async {
    DateTime today = DateTime.now();
    String date = "${today.day}-${today.month}-${today.year}";

    SensorModel? sensorModel = sensorBox.get(date);

    if (sensorModel == null) return null;

    return sensorModel;
  }

  bool _sensorDataUploaded = false;
  Future<void> uploadSensorData() async {
    if (_sensorDataUploaded) return;
    _sensorDataUploaded = true;

    String uid = FirebaseAuth.instance.currentUser!.uid;

    SensorModel? data = await readFromBox();
    if (data == null) return;

    TaskSnapshot sensorDataUploadTask = await FirebaseStorage.instance
        .ref(uid)
        .child("sensor_data")
        .child(DateTime.now().toString())
        .putString(data.toJson(), format: PutStringFormat.raw);

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
