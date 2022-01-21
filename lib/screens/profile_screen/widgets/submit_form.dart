import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/controllers/profile/basic_detail/basic_detail_controller.dart';
import 'package:buzz_ai/controllers/profile/contact_detail/contact_detail_controller.dart';
import 'package:buzz_ai/controllers/profile/emergency_contacts/fifth_emergency_contact_controller.dart';
import 'package:buzz_ai/controllers/profile/emergency_contacts/first_emergency_contact_controller.dart';
import 'package:buzz_ai/controllers/profile/emergency_contacts/fourth_emergency_contact_controller.dart';
import 'package:buzz_ai/controllers/profile/emergency_contacts/second_emergency_contact_controller.dart';
import 'package:buzz_ai/controllers/profile/emergency_contacts/third_emergency_contact_controller.dart';
import 'package:buzz_ai/controllers/profile/multiple_car/multiple_car_controller.dart';
import 'package:buzz_ai/controllers/profile/user_profile/user_profile_controller.dart';
import 'package:buzz_ai/controllers/profile/vehicle_info/vehicle_info_controller.dart';
import 'package:buzz_ai/models/profile/user_profile/user_profile.dart';
import 'package:buzz_ai/screens/bottom_navigation/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class SubmitForm extends StatefulWidget {
  final bool isFromSIgnUp;

  const SubmitForm({Key? key, required this.isFromSIgnUp}) : super(key: key);

  @override
  State<SubmitForm> createState() => _SubmitFormState();
}

class _SubmitFormState extends State<SubmitForm> {
  late UserProfileController userProfileController;
  late AuthenticationController authenticationController;
  late Box<bool> profileBox;
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
    profileBox = Hive.box<bool>('profileBox');
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
    bool areValid = await userProfileController.validateForms(context: context);
    bool isEmergencyValid =
        await userProfileController.validateEmergency(context: context);

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
    final emergencySnackBar = SnackBar(
      duration: const Duration(seconds: 3),
      content: const Text('Emergency contact information not set'),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          ScaffoldMessenger.of(context).clearSnackBars();
        },
      ),
    );

    if (!isEmergencyValid) {
      ScaffoldMessenger.of(context).showSnackBar(emergencySnackBar);
      return;
    }

    if (!areValid) {
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
      firstEmergencyContact:
          Provider.of<FirstEmergencyContactController>(context, listen: false)
              .firstEmergencyContact,
      secondEmergencyContact:
          Provider.of<SecondEmergencyContactController>(context, listen: false)
              .secondEmergencyContact,
      thirdEmergencyContact:
          Provider.of<ThirdEmergencyContactController>(context, listen: false)
              .thirdEmergencyContact,
      fourthEmergencyContact:
          Provider.of<FourthEmergencyContactController>(context, listen: false)
              .fourthEmergencyContact,
      fifthEmergencyContact:
          Provider.of<FifthEmergencyContactController>(context, listen: false)
              .fifthEmergencyContact,
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
        duration: const Duration(seconds: 2),
        content: const Text('Profile Set'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
          },
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
      profileBox.put('profile', true);

      await Future.delayed(const Duration(seconds: 2), () {
        if (widget.isFromSIgnUp) {
          Navigator.of(context).pushNamed(BottomNavigation.iD);
        }
      });
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
