import 'dart:developer';

import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:buzz_ai/activity_recognition.dart';
import 'package:flutter/material.dart';

class NotificationsController extends ChangeNotifier {
  Future<void> update(ActivityRecognitionApp recognitionApp) async {
    if (recognitionApp.currentActivityEvent == null) return;
    if (recognitionApp.currentActivityEvent!.type == ActivityType.IN_VEHICLE) {
      await createVehicleActivityNotification();
    }
  }

  Future<void> createVehicleActivityNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title: '${Emojis.transport_automobile} Are you driving a Car?',
        body: 'We have detected a change in activity',
        notificationLayout: NotificationLayout.Default,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'yes_key',
          label: 'Yes',
        ),
        NotificationActionButton(
          key: 'no_key',
          label: 'No',
        ),
      ],
    );
    notifyListeners();
  }

  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }
}
