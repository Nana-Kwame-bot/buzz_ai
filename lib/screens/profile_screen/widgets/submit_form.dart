import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/controllers/profile/basic_detail/basic_detail_controller.dart';
import 'package:buzz_ai/controllers/profile/contact_detail/contact_detail_controller.dart';
import 'package:buzz_ai/controllers/profile/emergency_contact/emergency_contact_controller.dart';
import 'package:buzz_ai/controllers/profile/multiple_car/multiple_car_controller.dart';
import 'package:buzz_ai/controllers/profile/user_profile/user_profile_controller.dart';
import 'package:buzz_ai/controllers/profile/vehicle_info/vehicle_info_controller.dart';
import 'package:buzz_ai/models/profile/user_profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

class SubmitForm extends StatefulWidget {
  const SubmitForm({Key? key}) : super(key: key);

  @override
  State<SubmitForm> createState() => _SubmitFormState();
}

class _SubmitFormState extends State<SubmitForm> {
  late UserProfileController userProfileController;
  late AuthenticationController authenticationController;

  late DatabaseReference _userRef;
  UserProfile? userProfile;
  late String userId;

  @override
  void initState() {
    super.initState();
    userProfileController = Provider.of<UserProfileController>(
      context,
      listen: false,
    );
    authenticationController = Provider.of<AuthenticationController>(
      context,
      listen: false,
    );
    userId = authenticationController.auth.currentUser!.uid;
    _userRef = userProfileController.database.ref('users/$userId');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        bottom: 32.0,
      ),
      child: Consumer(
        builder:
            (BuildContext context, UserProfileController value, Widget? child) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: const Color(0xFF5247C5),
                shape: const StadiumBorder(),
                minimumSize: const Size(100, 35)),
            onPressed: value.formEnabled ? onPressed : null,
            child: const Text('SUBMIT'),
          );
        },
      ),
    );
  }

  Future<void> onPressed() async {
    final requiredSnackBar = SnackBar(
      duration: const Duration(seconds: 3),
      content: const Text('Please fill out all the required fields'),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          ScaffoldMessenger.of(context).clearSnackBars();
        },
      ),
    );

    if (!userProfileController.validateForms(context: context)) {
      ScaffoldMessenger.of(context).showSnackBar(requiredSnackBar);
      return;
    }

    userProfile = Provider.of<UserProfileController>(context, listen: false)
        .setProfileData(
      basicDetail: Provider.of<BasicDetailController>(context, listen: false)
          .basicDetail,
      contactDetail:
          Provider.of<ContactDetailController>(context, listen: false)
              .contactDetail,
      emergencyContact:
          Provider.of<EmergencyContactController>(context, listen: false)
              .emergencyContact,
      gender:
          Provider.of<UserProfileController>(context, listen: false).gender!,
      multipleVehicle:
          Provider.of<MultipleVehicleController>(context, listen: false)
              .multipleVehicle,
      vehicleInfo: Provider.of<VehicleInfoController>(context, listen: false)
          .vehicleInfo,
    );

    try {
      await _userRef.set(userProfile?.toMap());
      final successSnackBar = SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Profile Set'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
          },
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
    } on Exception catch (e) {
      final failureSnackBar = SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(e.toString()),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(failureSnackBar);
    }
  }
}
