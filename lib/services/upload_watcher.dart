import 'dart:async';
import 'dart:developer';

import 'package:buzz_ai/services/upload_sensor_data.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:path_provider/path_provider.dart';

import 'dart:io';

void startUploadWatcher() async {
  Stream<ConnectivityResult> connectivityStream =
      Connectivity().onConnectivityChanged;

  connectivityStream.listen((ConnectivityResult result) async {
    bool isOnline =
        [ConnectivityResult.mobile, ConnectivityResult.wifi].contains(result);

    if (isOnline) {
      // Upload pending sensorData as soon as device is online
      Directory dir = await getApplicationDocumentsDirectory();
      List<FileSystemEntity> pendingUploads = dir.listSync(recursive: true);
      pendingUploads.removeWhere((file) => !file.path.contains("sensor"));

      if (pendingUploads.isNotEmpty) {
        for (var pendingFile in pendingUploads) {
          File file = File(pendingFile.path);
          await uploadSensorData(file);
        }
      }
    }
  });
}
