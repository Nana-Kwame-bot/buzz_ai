// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:io';

import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ActivityRecognitionApp  with ChangeNotifier {

  StreamSubscription<ActivityEvent>? activityStreamSubscription;
  final List<ActivityEvent> _events = [];
  ActivityRecognition activityRecognition = ActivityRecognition();

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
    print(activityEvent);
      _events.add(activityEvent);
  }

  void onError(Object error) {
    print('ERROR - $error');
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
