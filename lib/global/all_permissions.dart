import 'package:permission_handler/permission_handler.dart';

List<Map<String, dynamic>> allPermissions = [
  {
    "permission": Permission.location,
    "name": "Location",
    "description": "To access features like maps and navigation.",
  },
  {
    "permission": Permission.locationAlways,
    "name": "Location Always",
    "description":
        "To monitor device activity for triggering SOS and other emergency features.",
  },
  {
    "permission": Permission.activityRecognition,
    "name": "Activity Recognition",
    "description":
        "To recognize if you are on foot or in vehicle to start recording your travel.",
  },
  {
    "permission": Permission.camera,
    "name": "Camera",
    "description": "To capture accidents.",
  },
  {
    "permission": Permission.microphone,
    "name": "Microphone",
    "description": "To record audio when an accident happens.",
  },
  {
    "permission": Permission.notification,
    "name": "Notification",
    "description": "To notify you with activity updates.",
  },
  {
    "permission": Permission.sms,
    "name": "Messaging",
    "description": "To notify your emergency contact with your accidents.",
  },
];
