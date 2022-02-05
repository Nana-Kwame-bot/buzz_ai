// import 'dart:developer';
//
// import 'package:buzz_ai/controllers/profile/user_profile/user_profile_controller.dart';
// import 'package:buzz_ai/models/profile/user_profile/user_profile.dart';
// import 'package:buzz_ai/services/bg_methods.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:telephony/telephony.dart';
//
// Future<void> sendSms(BuildContext context, Map<String, dynamic> data) async {
//   // await Provider.of<UserProfileController>(context, listen: false)
//   //     .readProfileData(userId: data["uid"], context: context);
//
//   UserProfile? user = await context
//       .read<UserProfileController>()
//       .readProfileData(userId: data["uid"], context: context);
//
//   DateTime now = DateTime.now();
//
//   String? name = user?.basicDetail!.fullName!;
//   String address = data["location"].toString();
//   String coords = data["coordinates"].toString();
//   String date = DateFormat("dd/MM/yyyy").format(now);
//   String time = DateFormat("HH:MM").format(now);
//
//   String message =
//       "Accident found from $name's device dated on $date at $time.\n\nCrash Severity: ${data["crashStatus"]} \nAddress: $address\nCoordinates: $coords";
//
//   List<String?> recipients = [
//     user?.firstEmergencyContact!.contactNumber!,
//     user?.secondEmergencyContact?.contactNumber,
//     user?.thirdEmergencyContact?.contactNumber,
//     user?.fourthEmergencyContact?.contactNumber,
//     user?.fifthEmergencyContact?.contactNumber,
//   ];
//
//   log("recipients + $recipients");
//
//   recipients.removeWhere((recipient) => recipient == null || recipient.isEmpty);
//
//   final Telephony telephony = Telephony.instance;
//   await telephony.requestPhoneAndSmsPermissions;
//
//   SmsSendStatusListener listener = (SendStatus status) {
//     log('SmsSendStatusListener ${status.toString()}');
//   };
//
//   for (String? recipient in recipients) {
//     telephony.sendSms(to: recipient!, message: message);
//     log("sms sent to $recipient + $message");
//   }
// }
