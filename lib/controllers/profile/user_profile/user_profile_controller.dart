import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'package:buzz_ai/controllers/profile/basic_detail/basic_detail_controller.dart';
import 'package:buzz_ai/controllers/profile/contact_detail/contact_detail_controller.dart';
import 'package:buzz_ai/controllers/profile/vehicle_info/vehicle_info_controller.dart';
import 'package:buzz_ai/models/profile/basic_detail/basic_detail.dart';
import 'package:buzz_ai/models/profile/contact_detail/contact_detail.dart';
import 'package:buzz_ai/models/profile/emergency_contact/emergency_contact.dart';
import 'package:buzz_ai/models/profile/gender/gender.dart';
import 'package:buzz_ai/models/profile/multiple_vehicle/multiple_vehicle.dart';
import 'package:buzz_ai/models/profile/user_profile/user_profile.dart';
import 'package:buzz_ai/models/profile/vehicle_info/vehicle_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileController extends ChangeNotifier {
  UserProfile userProfile = const UserProfile();

  bool validateForms({required BuildContext context}) {
    if (Provider.of<BasicDetailController>(context, listen: false)
        .validateBasicDetailForms() &&
        Provider.of<ContactDetailController>(context, listen: false)
            .validateContactDetailForms() &&
        Provider.of<VehicleInfoController>(context, listen: false)
            .validateVehicleForms()) {
      return true;
    }
    return false;
  }

  UserProfile setProfileData({
    required BasicDetail basicDetail,
    required ContactDetail contactDetail,
    required EmergencyContact emergencyContact,
    required Gender gender,
    required MultipleVehicle multipleVehicle,
    required VehicleInfo vehicleInfo,
  }) {
    userProfile = userProfile.copyWith(
      basicDetail: basicDetail,
      contactDetail: contactDetail,
      emergencyContact: emergencyContact,
      gender: gender,
      multipleVehicle: multipleVehicle,
      vehicleInfo: vehicleInfo,
    );

    return userProfile;
  }

  Future<void> readProfileData({required String userId}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$userId");
    // Get the data once
    DatabaseEvent event = await ref.once();

    DataSnapshot dataSnapshot = event.snapshot;

    //
    userProfile = UserProfile.fromMap(dataSnapshot.value as Map<String,dynamic>);
    // Print the data of the snapshot
    debugPrint(userProfile.toString());
  }

}
