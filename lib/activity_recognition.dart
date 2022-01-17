// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
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

  // Sensor variables
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  List<List<double>> _accelerometerValues = [];
  final List<List<double>> _gyroscopeValues = [];

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
    _streamSubscriptions.addAll(
      [
        accelerometerEvents.listen(
          (AccelerometerEvent event) {
            updateSensorValues("acc", <double>[event.x, event.y, event.z]);
          },
        ),
        gyroscopeEvents.listen(
          (GyroscopeEvent event) {
            updateSensorValues("gyro", <double>[event.x, event.y, event.z]);
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
  }

  void startTracking() {
    activityStreamSubscription = activityRecognition
        .activityStream(runForegroundService: true)
        .listen(onData, onError: onError);
  }

  void onData(ActivityEvent activityEvent) {
    _lastActivityEvent = currentActivityEvent;
    currentActivityEvent = activityEvent;

    print(activityEvent);
    _events.add(activityEvent);
  }

  void onError(Object error) {
    print('ERROR - $error');
  }

  void updateSensorValues(String event, List<double> data) async {
    if (currentActivityEvent == null) return;
    if (_lastActivityEvent == null) return;

    if (currentActivityEvent!.type == ActivityType.ON_FOOT) {
      if (event == "acc") {
        _accelerometerValues.add(data);
      }
      if (event == "gyro") {
        _gyroscopeValues.add(data);
      }

      log(data.toString());
    } else if (currentActivityEvent!.type == ActivityType.STILL) {
      if (_lastActivityEvent!.type != ActivityType.STILL) {
        _lastActivityEvent = null;
        writeToBox();
        log("Writing sensor data to box");
      }
    }
  }

  void writeToBox() async {
    Box box = await Hive.openBox("sensor_data");

    DateTime today = DateTime.now();
    String date = "${today.day}-${today.month}-${today.year}";

    box.put(date, {
      "accelerometerData": _accelerometerValues,
      "gyroscopeData": _gyroscopeValues,
    });
  }

  void readFromBox() async {
    DateTime today = DateTime.now();
    String date = "${today.day}-${today.month}-${today.year}";

    Box box = Hive.box("sensor_data");
    print(box.get(date));
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
