// ignore_for_file: unused_import

import 'dart:developer';
import 'dart:io';

import 'package:buzz_ai/activity_recognition.dart';
import 'package:buzz_ai/screens/sos/service/sms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

// Future<void> uploadReport(
//     BuildContext context, Map<String, dynamic> data) async {
//   ActivityRecognitionApp ara =
//       Provider.of<ActivityRecognitionApp>(context, listen: false);
//   String path = (await getApplicationDocumentsDirectory()).path;
//
//   if (ara.isAudioRecording) {
//     await ara.recorder.stop();
//   }
//
//   data["gForce"] = ara.excedeedGForce;
//
//   final ref =
//       FirebaseStorage.instance.ref(data["uid"]).child("audio/${ara.fileName}");
//
//   File audioFile = File("$path/${ara.fileName}");
//   await ref.putFile(audioFile);
//   var url = await ref.getDownloadURL();
//
//   data["audio"] = url;
//
//   FirebaseFirestore.instance
//       .collection("accidentDatabase")
//       .add(data)
//       .then((value) => sendSms(context, data));
//   log("sms sent");
//   audioFile.delete();
//
//   Provider.of<ActivityRecognitionApp>(context, listen: false).accidentReported =
//       true;
// }
