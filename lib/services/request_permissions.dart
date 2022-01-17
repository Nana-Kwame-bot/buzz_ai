import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';

List<Permission> allRequiredPermissions = [
  Permission.locationAlways,
  Permission.manageExternalStorage,
  Permission.storage,
  Permission.camera,
  Permission.sensors,
];

Future<void> requestAllPermission() async {
  for (int i = 0; i < allRequiredPermissions.length; i++) {
    PermissionStatus status = await allRequiredPermissions[i].request();
    log("${allRequiredPermissions[i]} ${status}");
  }
}