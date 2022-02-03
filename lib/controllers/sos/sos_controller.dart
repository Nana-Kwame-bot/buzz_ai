import 'package:buzz_ai/models/accident_data/accident_data.dart';
import 'package:buzz_ai/models/profile/user_profile/user_profile.dart';
import 'package:buzz_ai/services/get_location.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:io';
import 'package:buzz_ai/activity_recognition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:telephony/telephony.dart';

class SOSController extends ChangeNotifier {
  String? path;
  AccidentData accidentData = AccidentData(
    longitude: 0,
    latitude: 0,
    timeCreated: DateTime.now(),
    placemark: Placemark(),
    crashStatus: "",
    last30sG: [],
    audioURL: "",
    gForce: 0,
  );

  void upDateCrashStatus(String crashStatus) {
    accidentData = accidentData.copyWith(crashStatus: crashStatus);
    notifyListeners();
  }

  void onStart() async {
    path ??= await _localPath;
    notifyListeners();
  }

  Future<void> uploadReport({
    required ActivityRecognitionApp recognitionApp,
    required UserProfile userProfile,
    required String userID,
  }) async {
    accidentData = await getData(
      lastThirtyGForce: recognitionApp.last30GForce,
    );
    if (recognitionApp.isAudioRecording) {
      await recognitionApp.recorder.stop();
    }
    accidentData = accidentData.copyWith(gForce: recognitionApp.excedeedGForce);

    final ref = FirebaseStorage.instance
        .ref(userID)
        .child("audio/${recognitionApp.fileName}");

    File audioFile = File("$path/${recognitionApp.fileName}");
    await ref.putFile(audioFile);
    var url = await ref.getDownloadURL();

    accidentData = accidentData.copyWith(audioURL: url);

    await sendSms(user: userProfile);
    audioFile.delete();

    recognitionApp.accidentReported = true;
    await FirebaseFirestore.instance
        .collection("accidentDatabase")
        .add(accidentData.toMap());

    log("accidentData + ${accidentData.toMap().toString()}");
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<void> sendSms({
    required UserProfile user,
  }) async {
    DateTime now = DateTime.now();

    String? name = user.basicDetail!.fullName!;
    String address = accidentData.placemark.toString();
    String coordinates =
        [accidentData.latitude, accidentData.longitude].toString();
    String date = DateFormat("dd/MM/yyyy").format(now);
    String time = DateFormat("HH:MM").format(now);

    String message =
        "Accident found from $name's device dated on $date at $time."
        "\n\nCrash Severity: ${accidentData.crashStatus} "
        "\nAddress: $address\nCoordinates: $coordinates";

    List<String?> recipients = [
      user.firstEmergencyContact!.contactNumber!,
      user.secondEmergencyContact?.contactNumber,
      user.thirdEmergencyContact?.contactNumber,
      user.fourthEmergencyContact?.contactNumber,
      user.fifthEmergencyContact?.contactNumber,
    ];

    log("recipients + $recipients");

    recipients.removeWhere((recipient) {
      return recipient == null || recipient.isEmpty;
    });

    final Telephony telephony = Telephony.instance;
    await telephony.requestPhoneAndSmsPermissions;

    for (String? recipient in recipients) {
      telephony.sendSms(
        to: recipient!,
        message: message,
        statusListener: (SendStatus status) {
          log('SmsSendStatus ${status.toString()}');
        },
      );
      log("sms sent to $recipient + $message");
    }
  }

  Future<AccidentData> getData({
    required List<double> lastThirtyGForce,
  }) async {
    Map<String, dynamic>? locationData;

    try {
      locationData = await getLocation();
    } catch (e) {
      log(e.toString());
    }
    List<double> last30sG = lastThirtyGForce;

    if (locationData == null) {
      return accidentData;
    }

    return AccidentData(
      timeCreated: DateTime.now(),
      placemark: locationData["placemark"],
      crashStatus:
          accidentData.crashStatus == "" ? "Crash" : accidentData.crashStatus,
      last30sG: last30sG,
      latitude: locationData["position"]?.latitude,
      longitude: locationData["position"]?.longitude,
      audioURL: '',
      gForce: 0,
    );
  }
}
