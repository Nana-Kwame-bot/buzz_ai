// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:activity_recognition_flutter_mod/activity_recognition_flutter.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bringtoforeground/bringtoforeground.dart';
import 'package:buzz_ai/api/sound_recorder.dart';
import 'package:buzz_ai/main.dart';
import 'package:flutter/foundation.dart';
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
  DateTime lastUpdate = DateTime.now();
  bool _activityRecognitionWorkingNotified = false;

  bool gForceExceeded = false;
  double? excedeedGForce;
  bool accidentReported = false;
  SoundRecorder recorder = SoundRecorder();
  late String fileName = "${DateTime.now()}.aac";
  bool isAudioRecording = false;
  bool notificationShown = false;

  // Sensor variables
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  final List<List<double>> _accelerometerValues = [];
  final List<List<double>> _gyroscopeValues = [];
  DateTime _lastWritten = DateTime.now();
  late SharedPreferences prefs;
  List<double> last30GForce = [];
  double lastGForce = 0;

  int throttleAmount = 66; // In milliseconds.

  @override
  void dispose() {
    recorder.dispose();
    activityStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> init() async {
    _events.add(ActivityEvent.unknown());

    recorder.init();
    prefs = await SharedPreferences.getInstance();
    Timer.periodic(const Duration(seconds: 1), (timer) => last30GForce = []);

    _streamSubscriptions.addAll(
      [
        userAccelerometerEvents.listen(
          (UserAccelerometerEvent event) {
            lastGForce = checkGForce(event);

            if (event.x <= -6 && event.y <= -6 && event.z <= -6) {
              if (!gForceExceeded) {
                recordAudio();

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
          (GyroscopeEvent event) => _throttle(
              updateSensorValues, "gyro", <double>[event.x, event.y, event.z]),
        ),
      ],
    );

    // Android requires explicitly asking permission
    if (Platform.isAndroid) {
      if (await Permission.activityRecognition.isGranted) {
        startTracking();
      } else {
        await Permission.activityRecognition.request().then((status) {
          if (status.isGranted) startTracking();
        });
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

    _events.add(activityEvent);
    notifyListeners();
  }

  void onError(Object error) {
    if (kDebugMode) {
      print('ERROR - $error');
    }
  }

  double checkGForce(UserAccelerometerEvent event) =>
      ((event.x + event.y + event.z) / 3) / 9.8;

  void updateSensorValues(String event, List<double> data) async {
    last30GForce.add(lastGForce);

    if (currentActivityEvent == null) return;
    if (_lastActivityEvent == null) return;

    if (!_activityRecognitionWorkingNotified) showActivityRecognitionActive();

    if (currentActivityEvent!.type == ActivityType.IN_VEHICLE) {
      _updateActivityNotification(currentActivityEvent!);

      if (event == "acc") {
        _accelerometerValues.add(data);
      }
      if (event == "gyro") {
        _gyroscopeValues.add(data);
      }

      // dev.log(data.toString());
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

  void showActivityRecognitionActive() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: 'activity_change',
        title: "Activity Recognition initialized successfully!",
        autoDismissible: true,
      ),
      actionButtons: [
        NotificationActionButton(
          key: "dismiss",
          label: "Dismiss",
          isDangerousOption: true,
          buttonType: ActionButtonType.DisabledAction,
        ),
      ],
    );

    _activityRecognitionWorkingNotified = true;
  }

  _updateActivityNotification(ActivityEvent currentActivityEvent) {
    if (currentAppState != AppLifecycleState.paused) return;

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    String title = "";
    String body = "";
    if (currentActivityEvent.type == ActivityType.ON_FOOT) {
      title = "Are you driving?";
      body =
          "Please open the application if you're driving so that we can ensure your safety";
    }

    if (!notificationShown && currentAppState == AppLifecycleState.paused) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'activity_change',
          title: title,
          body: body,
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
      notificationShown = true;
      Timer.periodic(
          const Duration(minutes: 1),
          (timer) => notificationShown =
              false); // Reset the notificatinShown anyway after a minute
      notifyListeners();
    }
  }

  Future<void> recordAudio() async {
    isAudioRecording = await recorder.isRecording;
    if (isAudioRecording) return;

    fileName = "${DateTime.now()}.aac";
    await recorder.record(fileName);

    Future.delayed(const Duration(seconds: 3)).then((value) async {
      await recorder.stop();
      isAudioRecording = await recorder.isRecording;
    });
  }

  _throttle(Function callback, String sensor, List<double> event) async {
    if (DateTime.now().difference(lastUpdate).inMilliseconds < throttleAmount)
      return;

    callback(sensor, event);
    // dev.log("Callback called after being throttled for [${DateTime.now().difference(lastUpdate).inMilliseconds}'ms]");
    lastUpdate = DateTime.now();
  }
}
