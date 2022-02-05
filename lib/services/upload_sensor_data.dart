import 'dart:developer';
import 'dart:io';

import 'package:buzz_ai/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

Future<bool> uploadSensorData([File? file]) async {
  try {
    DateTime yesterday = DateTime.now().add(const Duration(days: -1));
    DateTime today = DateTime.now();

    if (today.hour == 2 && today.minute >= 29) {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String data = await readSensorData(file);

      log("⬆️  Uploading sensor data...");
      TaskSnapshot sensorDataUploadTask = await FirebaseStorage.instance
          .ref(uid)
          .child("sensor_data")
          .child("${yesterday.day}-${yesterday.month}-${yesterday.year}.csv")
          .putString(data, format: PutStringFormat.raw);

      await FirebaseFirestore.instance.collection("userDatabase").doc(uid).set(
        {
          "sensorData": FieldValue.arrayUnion([
            {
              "timestamp": DateTime.now(),
              "filePath": await sensorDataUploadTask.ref.getDownloadURL()
            }
          ])
        },
        SetOptions(merge: true),
      );
      log("✅ Sensor data uploaded.");

      Directory dir = await getApplicationDocumentsDirectory();
      if (file == null) {
        await File(
                "${dir.path}/sensordata-${today.day}-${today.month}-${today.year}.csv")
            .delete();
        return true;
      }
      await file.delete();
      return true;
    }
    return false;
  } catch (e) {
    log("❌ Background sensor data upload failed", error: e);
    return false;
  }
}

Future<String> readSensorData([File? infile]) async {
  Directory dir = await getApplicationDocumentsDirectory();
  DateTime today = DateTime.now();
  File file = infile ??
      File(
          "${dir.path}/sensordata-${today.day}-${today.month}-${today.year}.csv");

  return await file.readAsString();
}
