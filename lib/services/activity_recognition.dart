import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ActivityRecognitionService {
  ActivityRecognition activityRecognition = ActivityRecognition();
  StreamSubscription<ActivityEvent>? activityStreamSubscription;
  late List<ActivityEvent> _events = [];
  ActivityEvent? currentActivityEvent;
  ActivityEvent? _lastActivityEvent;

  // Sensor variables
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  List<List<double>> _accelerometerValues = [];
  List<List<double>> _gyroscopeValues = [];

  ActivityRecognitionService() {
    monitorActivity();
    _events.add(ActivityEvent.unknown());
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
  }

  void monitorActivity() async {
    if (Platform.isAndroid) {
      if (await Permission.activityRecognition.request().isGranted) {
        startTracking();
      }
    }
    startTracking();
  }

  void startTracking() {
    activityStreamSubscription = activityRecognition
        .activityStream(runForegroundService: true)
        .listen(onData, onError: onError);
  }

  void onData(ActivityEvent activityEvent) {
    _lastActivityEvent = currentActivityEvent == _lastActivityEvent
        ? null
        : currentActivityEvent;
    currentActivityEvent = activityEvent;
    log("Activity: $activityEvent");

    if (activityEvent.type == ActivityType.IN_VEHICLE) {
      _accelerometerValues = []; // Clear existing values
    }

    // if ()

    _events.add(activityEvent);
  }

  void onError(Object error) {
    log('ERROR - $error');
  }

  void updateSensorValues(String event, List<double> data) async {
    if (currentActivityEvent == null) return;

    if (currentActivityEvent!.type == ActivityType.IN_VEHICLE) {
      if (event == "acc") {
        _accelerometerValues.add(data);
      }
      if (event == "gyro") {
        _gyroscopeValues.add(data);
      }

      log(data.toString());
    } else if (currentActivityEvent!.type == ActivityType.STILL &&
        _lastActivityEvent != null) {
      if (_lastActivityEvent!.type != ActivityType.STILL) {
        Directory directory = await getApplicationDocumentsDirectory();
        File sensorDataFile =
            File('${directory.path}/sensor_data/data_${DateTime.now()}.txt');

        sensorDataFile.writeAsString(
          jsonEncode({
            "accelerometerData": _accelerometerValues,
            "gyroscopeData": _gyroscopeValues,
          }),
        );
      }
    }

    Directory directory = await getApplicationDocumentsDirectory();
    File sensorDataFile =
        File('${directory.path}/sensor_data/data_${DateTime.now()}.txt');

    await sensorDataFile.writeAsString(
      jsonEncode({
        "accelerometerData": _accelerometerValues,
        "gyroscopeData": _gyroscopeValues,
      }),
    );
  }

  void dispose() {
    activityStreamSubscription?.cancel();
  }
}
