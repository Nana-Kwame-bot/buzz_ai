// import 'package:flutter/material.dart';
// import 'package:buzz_ai/activity_recognition.dart';
// import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
// import 'package:buzz_ai/services/get_location.dart';
// import 'package:provider/provider.dart';
//
// Future<Map<String, dynamic>> getData(BuildContext context) async {
//   Map? locationData;
//
//   try {
//     locationData = await getLocation();
//   } catch (e) {
//     locationData = null;
//     // rethrow;
//   }
//
//   String uid = Provider.of<AuthenticationController>(context, listen: false)
//       .auth
//       .currentUser!
//       .uid;
//   List<double> last30sG =
//       Provider.of<ActivityRecognitionApp>(context, listen: false).last30GForce;
//
//   return {
//     "coordinates": locationData == null
//         ? null
//         : [
//             locationData["position"].latitude,
//             locationData["position"].longitude
//           ],
//     "createdAt": DateTime.now(),
//     "location":
//         locationData == null ? null : locationData["placemark"].toJson(),
//     "uid": uid,
//     "crashStatus": "Crash",
//     "last30sG": last30sG,
//   };
// }
