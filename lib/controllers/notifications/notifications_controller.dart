import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationsController extends ChangeNotifier {
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
  }

  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }
}
